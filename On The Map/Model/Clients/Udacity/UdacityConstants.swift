//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/13/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

extension UdacityClient {
    
    //MARK: Methods
    struct Methods {
        
        static let Session = "https://www.udacity.com/api/session"
        static let UserData = "https://www.udacity.com/api/users"
        
        
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let UserInfo = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }
    
    
}
