//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Egorio on 2/5/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation

/*
 * API client for Udacity.com
 */
class UdacityClient: ApiClient {

    var sessionId: String? = nil
    var userId: String? = nil

    let apiUrl = "https://www.udacity.com/api/"

    // Singleton instance of UdacityClient
    static let shared = UdacityClient()

    private override init() {
        super.init()
        
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }

    /*
     * Process response data for next parsing
     */
    override func processResponseData(data: NSData?) -> NSData? {
        return data?.subdataWithRange(NSMakeRange(5, data!.length - 5))
    }

    /*
     * Login to API using username (email) and password
     */
    func createSession(username: String, password: String, handler: (error: String?) -> Void) {

        let request = prepareRequest("\(apiUrl)session", method: .Post, body: [
            "udacity": [
                "username": username,
                "password": password
            ]
        ])

        processResuest(request) { (result, error) in
            // Check for error
            guard error == nil else {
                handler(error: error)
                return
            }

            // Loging for ["account"]["key"]
            guard let account = result!["account"] as? [String : AnyObject], let userId = account["key"] as? String else {
                print("Can't find [account][key] in response")
                handler(error: "Username or password is incorrect")
                return
            }

            // Loging for ["session"]["id"]
            guard let session = result!["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                print("Can't find [session][id] in response")
                handler(error: "Username or password is incorrect")
                return
            }

            self.sessionId = sessionId
            self.userId = userId

            handler(error: nil)
        }
    }

    /*
     * Logout from API
     */
    func deleteSession(handler: (error: String?) -> Void) {

        let request = prepareRequest("\(apiUrl)session", method: .Delete)

        // Add XSRF header to request
        for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! where cookie.name == "XSRF-TOKEN" {
            request.setValue(cookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        processResuest(request) { (result, error) -> Void in
            // Check for error
            guard error == nil else {
                handler(error: error)
                return
            }

            // Loging for ["session"]["id"]
            guard let session = result!["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                print("Can't find [session][id] in response")
                handler(error: "Connection error")
                return
            }

            self.sessionId = sessionId
            self.userId = nil

            handler(error: nil)
        }
    }

    /*
     * Return current user info
     */
    func getUser(id: String, handler: (user: UdacityUser?, error: String?) -> Void) {

        let request = prepareRequest("\(apiUrl)users/\(id)")

        processResuest(request) { (result, error) -> Void in
            // Check for error
            guard error == nil else {
                handler(user: nil, error: error)
                return
            }

            guard let userData = result!["user"] as? [String : AnyObject] else {
                print("Can't find [user] in response")
                handler(user: nil, error: "Connection error")
                return
            }

            guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                print("Can't find [user]['first_name'] or [user]['last_name'] in response")
                handler(user: nil, error: "Connection error")
                return
            }

            let user = UdacityUser(dictionary: [
                "id": id,
                "firstName": firstName,
                "lastName": lastName,
            ])

            handler(user: user, error: nil)
        }
    }
}
