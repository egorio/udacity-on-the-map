//
//  PinController.swift
//  OnTheMap
//
//  Created by Egorio on 2/9/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import MapKit

class PinController: UIViewController, MKMapViewDelegate {

    var location: String = ""
    var coordinate: CLLocationCoordinate2D?

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        showStepOne()
    }

    /*
     * Cancel student location editing
     */
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
     * Search user coordinate by location, show it map and go to the step two
     */
    @IBAction func search(sender: UIButton) {
        // Location can't be empty
        guard let location = answerField.text where location != "" else {
            showErrorAlert("You have to enter your location first")
            return
        }

        LoadingOverlay.shared.showOverlay(view)

        // Try to find coordinates of address... and show preview on map and save it for next step
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            LoadingOverlay.shared.hideOverlayView()

            guard error == nil else {
                self.showErrorAlert("Could not find your location")
                return
            }

            self.location = location
            self.coordinate = placemark!.first!.location!.coordinate
            self.pin(self.coordinate!)
            self.showStepTwo()
        }
    }

    /*
     * Submit entered coordinates and link to Parse students storage
     */
    @IBAction func submit(sender: UIButton) {
        // Url can't be empty
        guard let url = answerField.text where url != "" else {
            showErrorAlert("You have to enter a link to share with other students")
            return
        }

        // Check the string as a link
        guard let link = NSURL(string: url) where UIApplication.sharedApplication().canOpenURL(link) else {
            showErrorAlert("Oops... looks like it's not a link.\nPlease start from \"http://\"")
            return
        }

        LoadingOverlay.shared.showOverlay(view)

        // Try to load current user data, because student mark depends on it
        // We have to load user data each time because user can update it anytime
        UdacityClient.shared.getUser(UdacityClient.shared.userId!) { (user, error) -> Void in

            guard error == nil else {
                dispatch_async(dispatch_get_main_queue(), {
                    LoadingOverlay.shared.hideOverlayView()
                    self.showErrorAlert(error!)
                })
                return
            }

            // Student data doesn't matter creating or updating
            let student = ParseStudent(dictionary: [
                "firstName": user!.firstName,
                "lastName": user!.lastName,
                "longitude": Double(self.coordinate!.longitude),
                "latitude": Double(self.coordinate!.latitude),
                "mediaURL": url,
                "mapString": self.location,
                "uniqueKey": user!.id,
                "objectId": "",
            ])

            if Storage.shared.student == nil {
                // Create student
                ParseClient.shared.putStudent(student, handler: self.studentSaveHandler)
            }
            else {
                // Update student
                student.objectId = Storage.shared.student!.objectId
                ParseClient.shared.putStudent(student, handler: self.studentSaveHandler)
            }
        }
    }

    /*
     * Prepare screen views to step one - "Enter location"
     */
    private func showStepOne() {
        location = ""
        coordinate = nil

        questionLabel.text = "Where are you\nstudying today?"
        answerField.text = ""
        answerField.placeholder = "Enter your location here"
        searchButton.hidden = false
        submitButton.hidden = true
        mapViewHeight.constant = 0
    }

    /*
     * Prepare screen views to step two - "Enter link"
     */
    private func showStepTwo() {
        questionLabel.text = "What is the link\nyou want to share?"
        answerField.text = ""
        answerField.placeholder = "Enter your link here"
        searchButton.hidden = true
        submitButton.hidden = false

        // Show map animated :)
        UIView.animateWithDuration(0.5, animations: {
            self.mapViewHeight.constant = self.answerField.frame.size.height / 2
            self.view.layoutIfNeeded()
        })
    }

    /*
     * Create "pin" on the map with coordinates (preview the mark on map)
     */
    private func pin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location

        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01))

        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        })
    }

    /*
     * Function will be called when student created or updated
     */
    private func studentSaveHandler(error: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            LoadingOverlay.shared.hideOverlayView()

            guard error == nil else {
                self.showErrorAlert(error!)
                return
            }

            // Refresh map and table
            let navigationController = self.presentingViewController as! UINavigationController
            let mainController = navigationController.viewControllers.first as! MainController
            mainController.refresh(nil)

            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
