//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/26/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    
    func getMultipleStudents(completionHandlerForMultipleStudents: @escaping (_ results: [ParseStudent]?, _ error: NSError?) -> Void){
        
        let parameters = [ParseClient.ParameterKeys.Limit: "100", ParseClient.ParameterKeys.Order: "-updatedAt"]
        let method: String = Methods.MultiStudentLocation
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
        
            if let studentResults = results?[JSONBodyResponse.StudentResults] as? [[String:AnyObject]] {
                let students = ParseStudent.studentsFromResults(studentResults)
                completionHandlerForMultipleStudents(students, nil)
            } else {
                completionHandlerForMultipleStudents(nil, NSError(domain:"getMultipleStudnets", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMultipleStudents"]))
            }
        }
    }
    
    func postStudentLocation(_ student: ParseStudent, completionHandlerForPostStudnet: @escaping (_ results: AnyObject?, _ errorString: String?) -> Void){
        
        /*
         Fix the jsonBody string.  Pass in new student as parameter.
         */
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(student.uniqueKey as! String)\", \"\(JSONBodyKeys.FirstName)\": \"\(student.firstName as! String)\", \"\(JSONBodyKeys.LastName)\": \"\(student.lastName as! String)\",\"\(JSONBodyKeys.MapString)\": \"\(student.mapString as! String)\", \"\(JSONBodyKeys.MediaURL)\": \"\(student.mediaURL as! String)\",\"\(JSONBodyKeys.Latitude)\": \(student.latitude as! Double), \"\(JSONBodyKeys.Longitude)\": \(student.longitude as! Double)}"
        
        let method: String = Methods.MultiStudentLocation
        
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, errorString) in
            
            if let error = errorString {
                completionHandlerForPostStudnet(nil, errorString)
            } else {
                
                completionHandlerForPostStudnet(results, nil)
            }
            
            
        }
    }
}
