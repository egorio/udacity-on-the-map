//
//  Storage.swift
//  OnTheMap
//
//  Created by Egorio on 2/11/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation

/*
 * It's a sort of local data storage :)
 */
class Storage {

    // Current logged in user
    var user: UdacityUser? = nil

    // Student for current user
    var student: ParseStudent? = nil

    // Student list for map and table
    var students: [ParseStudent] = [ParseStudent]()

    /*
     * Return the singleton instance of Storage
     */
    class var shared: Storage {
        struct Static {
            static let instance: Storage = Storage()
        }
        return Static.instance
    }
}
