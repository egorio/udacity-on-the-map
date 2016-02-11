//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Egorio on 2/9/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation

/*
 * Parse Student model
 */
class ParseStudent {

    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mediaUrl: String
    var mapString: String
    var objectId: String
    var uniqueKey: String

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    /*
     * Construct a student from a dictionary
     */
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as! String!
        lastName = dictionary["lastName"] as! String!
        longitude = dictionary["longitude"] as! Double
        latitude = dictionary["latitude"] as! Double
        mediaUrl = dictionary["mediaURL"] as! String!
        mapString = dictionary["mapString"] as! String!
        objectId = dictionary["objectId"] as! String!
        uniqueKey = dictionary["uniqueKey"] as! String!
    }
}
