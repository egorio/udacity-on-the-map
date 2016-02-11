//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Egorio on 2/9/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

extension UIViewController {

    /*
     * Show alert with title "Error", message and one button to dismiss the alert
     */
    func showErrorAlert(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .Default) { (action: UIAlertAction!) in
            controller.dismissViewControllerAnimated(true, completion: nil)
        })

        self.presentViewController(controller, animated: true, completion: nil)
    }

    /*
     * Show alert with message and two buttons
     */
    func showConfirmationAlert(message: String, dismissButtonTitle: String = "Cancel", actionButtonTitle: String = "OK", handler: ((UIAlertAction!) -> Void)) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .Alert)

        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .Default) { (action: UIAlertAction!) in
            controller.dismissViewControllerAnimated(true, completion: nil)
        })

        controller.addAction(UIAlertAction(title: actionButtonTitle, style: .Default, handler: handler))

        self.presentViewController(controller, animated: true, completion: nil)
    }

    /*
     * Present alert with specific storyboard identifier
     */
    func presentViewControllerWithIdentifier(identifier: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier(identifier)
        presentViewController(controller, animated: animated, completion: completion)
    }

    /*
     * Open link in the new screen if it's possible otherwise show error message
     */
    func openUrl(url: String) {
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: url) where app.canOpenURL(url) {
            app.openURL(url)
        }
        else {
            showErrorAlert("Looks like it's not a link :'(")
        }
    }
}
