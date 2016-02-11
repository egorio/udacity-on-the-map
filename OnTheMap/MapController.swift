//
//  MapController.swift
//  OnTheMap
//
//  Created by Egorio on 2/5/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }

    /*
     * Populate map with student's pins
     */
    func refresh() {
        mapView.removeAnnotations(mapView.annotations)

        var annotations = [MKPointAnnotation]()

        for student in Storage.shared.students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = student.fullName
            annotation.subtitle = student.mediaUrl

            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
    }

    /*
     * Return one pin to the map
     */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }

        return pin
    }

    /*
     * Try to open user's link when pin annotation is tapped
     */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            openUrl((view.annotation!.subtitle!)!)
        }
    }
}