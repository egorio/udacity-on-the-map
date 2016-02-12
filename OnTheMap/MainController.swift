//
//  MainController.swift
//  OnTheMap
//
//  Created by Egorio on 2/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation
import UIKit

class MainController: UITabBarController {

    var user: UdacityUser?
    var student: ParseStudent?

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh(nil)
    }

    /*
     * Logout user from API and application
     */
    @IBAction func logout(sender: UIBarButtonItem) {
        showConfirmationAlert("Would you like to logout?", actionButtonTitle: "Logout") { (action) in
            // Try to delete API session for more security
            UdacityClient.shared.deleteSession { (error) -> Void in }

            // Go to login screen
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    /*
     * Add user mark to the map
     */
    @IBAction func pin(sender: UIBarButtonItem) {
        // Check whether current user have already posted mark ot not or not
        ParseClient.shared.getStudent(UdacityClient.shared.userId!) { (student, error) in
            dispatch_async(dispatch_get_main_queue(), {
                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }

                if student == nil {
                    self.presentViewControllerWithIdentifier("PinController")
                }
                else {
                    self.showConfirmationAlert("You have already posted mark \"\(student!.fullName) as \(student!.mapString)\". Would you like to overwrite it?", actionButtonTitle: "Overwrite") { (action) in
                        self.presentViewControllerWithIdentifier("PinController")
                    }
                }
            })
        }
    }

    /*
     * Refresh map and table using fresh API data
     */
    @IBAction func refresh(sender: UIBarButtonItem?) {
        // By one overlay for each tab
        let overlays = [LoadingOverlay(), LoadingOverlay()]

        // Show overlays on each tab "body"
        for i in 0 ... 1 {
            overlays[i].showOverlay(viewControllers![i].view)
        }

        ParseClient.shared.getStudents { (students, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                // Hide all overlays
                for i in 0 ... 1 {
                    overlays[i].hideOverlayView()
                }

                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }

                // Update students in the local storage
            
                // Refresh markers on map and cells in table
                (self.viewControllers![0] as! MapController).refresh()
                (self.viewControllers![1] as! ListController).refresh()
            })
        }
    }
}