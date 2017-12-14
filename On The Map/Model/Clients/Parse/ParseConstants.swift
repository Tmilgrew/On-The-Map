//
//  ParseConstants.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/13/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

extension ParseClient {
    
    //MARK: Constants
    struct Constants{
        
        //MARK: Keys & IDs
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    //MARK: Methods
    struct Methods {
        
        static let MultiStudentLocation = "/StudentLocation"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys{
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        
        //used to get a single student location
        static let Where = "where"
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
    }
    
    //Mark: JSON Body Response
    struct JSONBodyResponse {
        static let StudentResults = "results"
        
        static let StudentLatitude = "latitude"
        static let StudentMapString = "mapString"
        static let StudentCreatedAt = "createdAt"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentObjectId = "objectId"
        static let StudentUpdatedAt = "updatedAt"
        static let StudentFirstName = "firstName"
        static let StudentLongitude = "longitude"
        static let StudentMediaURL = "mediaURL"
        static let StudentLastName = "lastName"
    }
}
