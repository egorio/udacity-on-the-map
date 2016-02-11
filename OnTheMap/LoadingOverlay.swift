//
//  LoadingOverlay.swift
//  OnTheMap
//
//  Created by Egorio on 2/5/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation
import UIKit

/*
 * Helper Loading Overlay hepls to show "process" state in application
 */
public class LoadingOverlay {

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    // Singleton instance of ParseClient
    static let shared = LoadingOverlay()

    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}