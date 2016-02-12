//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Egorio on 2/9/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation

/*
 * API client for Udacity Parse storage
 */
class ParseClient: ApiClient {

    let apiUrl = "https://api.parse.com/1/classes/"

    // Singleton instance of ParseClient
    static let shared = ParseClient()

    private override init() {
        super.init()
        
        self.headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type": "application/json",
        ]
    }

    /*
     * Returns student locations
     */
    func getStudents(handler: (students: [ParseStudent]?, error: String?) -> Void) {

        let request = prepareRequest("\(apiUrl)StudentLocation", params: ["limit": 100, "order": "-updatedAt"])

        processResuest(request) { (result, error) -> Void in
            guard error == nil else {
                handler(students: nil, error: error)
                return
            }

            guard let results = result!["results"] as? [[String : AnyObject]] else {
                print("Can't find [results] in response")
                handler(students: nil, error: "Connection error")
                return
            }

            Storage.shared.students = []
            
            for result in results {
                Storage.shared.students.append(ParseStudent(dictionary: result))
            }

            handler(students: Storage.shared.students, error: nil)
        }
    }

    /*
     * Get student by uniqueKey
     */
    func getStudent(uniqueKey: String, handler: (student: ParseStudent?, error: String?) -> Void) {

        let request = prepareRequest("\(apiUrl)StudentLocation", params: ["where": "{\"uniqueKey\":\"\(uniqueKey)\"}"])

        processResuest(request) { (result, error) -> Void in
            guard error == nil else {
                handler(student: nil, error: error)
                return
            }

            guard let results = result!["results"] as? [[String : AnyObject]] else {
                print("Can't find [results] in response")
                handler(student: nil, error: "Connection error")
                return
            }

            if let dictionary = results.first {
                Storage.shared.student = ParseStudent(dictionary: dictionary)
                handler(student: Storage.shared.student, error: nil)
            }
            else {
                handler(student: nil, error: nil)
            }
        }
    }

    /*
     * Create new student object in Parse storage
     */
    func postStudent(student: ParseStudent, handler: (error: String?) -> Void) {
        let request = prepareRequest("\(apiUrl)StudentLocation", method: .Post, body: [
            "uniqueKey": student.uniqueKey,
            "firstName": student.firstName,
            "lastName": student.lastName,
            "mapString": student.mapString,
            "mediaURL": student.mediaUrl,
            "latitude": student.latitude,
            "longitude": student.longitude,
        ])

        processResuest(request) { (result, error) -> Void in
            handler(error: error)
        }
    }

    /*
     * Update existing student object in Parse storage
     */
    func putStudent(student: ParseStudent, handler: (error: String?) -> Void) {
        let request = prepareRequest("\(apiUrl)StudentLocation/\(student.objectId)", method: .Put, body: [
            "uniqueKey": student.uniqueKey,
            "firstName": student.firstName,
            "lastName": student.lastName,
            "mapString": student.mapString,
            "mediaURL": student.mediaUrl,
            "latitude": student.latitude,
            "longitude": student.longitude,
        ])

        processResuest(request) { (result, error) -> Void in
            handler(error: error)
        }
    }
}