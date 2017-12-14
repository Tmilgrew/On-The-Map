//
//  ParseStudent.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/26/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation

struct ParseStudent {
    
    var firstName: String?
    var lastName: String?
    var objectID: String?
    var uniqueKey: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    
    init(dictionary: [String:AnyObject]){
        firstName = dictionary[ParseClient.JSONBodyResponse.StudentFirstName] as? String
        lastName = dictionary[ParseClient.JSONBodyResponse.StudentLastName] as? String
        objectID = dictionary[ParseClient.JSONBodyResponse.StudentObjectId] as? String
        uniqueKey = dictionary[ParseClient.JSONBodyResponse.StudentUniqueKey] as? String
        mapString = dictionary[ParseClient.JSONBodyResponse.StudentMapString] as? String
        mediaURL = dictionary[ParseClient.JSONBodyResponse.StudentMediaURL] as? String
        latitude = dictionary[ParseClient.JSONBodyResponse.StudentLatitude] as? Double
        longitude = dictionary[ParseClient.JSONBodyResponse.StudentLongitude] as? Double
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [ParseStudent] {
        
        var students = [ParseStudent]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(ParseStudent(dictionary: result))
        }
        
        return students
    }
    
    func hasNilValues () -> Bool {
        if (firstName==nil || lastName==nil || mediaURL==nil || latitude==nil || longitude==nil){
            return true
        }else{
            return false
        }
    }
}
