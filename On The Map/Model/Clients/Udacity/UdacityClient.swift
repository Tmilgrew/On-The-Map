//
//  UdacityClient.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/13/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var sessionID: String? = nil
    var userID: String? = nil
    var session = URLSession.shared
    
    
//    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//
//        //Set the parameters
//
//    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ errorString: String?) -> Void) -> URLSessionDataTask {
        
        //Set the parameters
        let parameters = parameters
        
        //Build URL & make the request
        var request = URLRequest(url: URL(string: Methods.Session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ errorString: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]

                completionHandlerForPOST(nil, errorString)
            }
            
            /* Was there an error? */
            guard error == nil else {
                sendError(error?.localizedDescription as! String)
                return
            }
            
            /* Did it return a 200 status code */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* Mandatory code provided by Udacity in order to use parse their response for security purposes */
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                completionHandlerForPOST(parsedResult, nil)
            } catch{
                sendError("Serialization failed")
            }
            
            
        }
        task.resume()
        return task
    }
    
    func taskForGetMethod(_ method: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        var request = URLRequest(url: URL(string: method)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain:"taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            guard let data = newData else {
                sendError("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                completionHandlerForGET(parsedResult, nil)
            } catch{
                sendError("Serialization failed")
            }
        }
        
        task.resume()
        return task
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
