//
//  LoginController.swift
//  OnTheMap
//
//  Created by Egorio on 2/4/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
    }

    /*
     * Hide keyboard on press return + do action of current field (username = go to password, password - try to login)
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()

        if (textField === usernameField) {
            passwordField.becomeFirstResponder()
        } else if (textField === passwordField) {
            login()
        }

        return true
    }

    /*
     * Login to application using email and password
     */
    @IBAction func login(sender: UIButton? = nil) {
        // Username and password can't be empty
        guard usernameField.text!.isEmpty == false && passwordField.text!.isEmpty == false else {
            showErrorAlert("Email or password is empty")
            return
        }

        LoadingOverlay.shared.showOverlay(view)

        // Try to login with Udacity API
        UdacityClient.shared.createSession(usernameField.text!, password: passwordField.text!) { (error: String?) in
            dispatch_async(dispatch_get_main_queue(), {
                LoadingOverlay.shared.hideOverlayView()

                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }

                self.presentViewControllerWithIdentifier("NavigationController")
            })
        }
    }

    /*
     * Display "Create new account" web page
     */
    @IBAction func register(sender: UIButton) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    /*
     * Login with facebook API auth
     */
    @IBAction func loginWithFacebook(sender: UIButton) {
    }
}
