//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Egorio on 2/5/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

/*
 * Parse User model
 */
struct UdacityUser {

    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    /*
     * Construct a user from a dictionary
     */
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
