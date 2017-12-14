//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/15/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func authenticate(_ username:String,_ password: String, _ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void){
        
        getSessionID(username, password) {(results, errorString) in
            
            if let errorString = errorString {
                print("\(errorString)")
                completionHandlerForAuth(false, errorString)
            } else {
                self.sessionID = results?[0]
                self.userID = results?[1]
                print("success in authenticate method!!!  Session ID is \(self.sessionID) and userID is \(self.userID)")
                completionHandlerForAuth(true, nil)
            }
        }
    
    }
    
    
    func getSessionID(_ username: String, _ password: String, _ completionHandlerForToken: @escaping (_ results: [String]?, _ errorString: NSError?) -> Void){
        
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        var request = URLRequest(url: URL(string: Methods.Session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        let session = URLSession.shared
        let _ = taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForToken(nil, error)
            } else {
                guard let sessionObject = result![UdacityClient.JSONResponseKeys.Session] as? [String:String] else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(result)")
                    return
                }
                
                guard let parsedSessionID = sessionObject[UdacityClient.JSONResponseKeys.ID] as? String else {
                    print ("Could not find \(UdacityClient.JSONResponseKeys.ID) in \(sessionObject)")
                    return
                }
                
                guard let accountObject = result![UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                    print("Could not find 1 \(UdacityClient.JSONResponseKeys.Account) in \(result)")
                    return
                }
                
                guard let key = accountObject[UdacityClient.JSONResponseKeys.Key] as? String else {
                    print("Could not find 2 \(UdacityClient.JSONResponseKeys.Key) in \(accountObject)")
                    return
                }
                
                let infoArray:[String] = [parsedSessionID, key]
                
                completionHandlerForToken(infoArray, nil)
            }
        }
        
    }
    
    func getUserInfo( completionHandlerForGetUserInfo: @escaping (_ results: [String:AnyObject], _ errorString: NSError?) -> Void){
        
        let method:String = "\(Methods.UserData)/\(self.userID!)"
        print(method)
        
        let _ = taskForGetMethod(method){
            (results, error) in
            
            if let error = error {
                print("There was an error")
                return
            }
            var dictionary:[String:AnyObject]
            
            guard let userInfo = results![UdacityClient.JSONResponseKeys.UserInfo] as? [String:AnyObject] else {
                print("Problem getting UserInfo")
                return
            }
            
            guard let lastName = userInfo[UdacityClient.JSONResponseKeys.LastName] as? String else {
                print("Couldn't get last name")
                return
            }
            
            guard let firstName = userInfo[UdacityClient.JSONResponseKeys.FirstName] as? String else {
                print("Couldn't get first name")
                return
            }
            
            dictionary =
                [
                    ParseClient.JSONBodyResponse.StudentFirstName: firstName as AnyObject,
                    ParseClient.JSONBodyResponse.StudentLastName: lastName as AnyObject,
                    ParseClient.JSONBodyResponse.StudentUniqueKey: self.userID as AnyObject
            ]
            
            completionHandlerForGetUserInfo(dictionary,nil)
        }
        
        
    }
}




