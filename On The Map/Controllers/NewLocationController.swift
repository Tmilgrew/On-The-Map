//
//  NewLocationController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 12/3/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit
import MapKit



class NewLocationController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var portfolioTextField: UITextField!
    @IBOutlet weak var debugText: UITextView!
    var geoCoder = CLGeocoder()
    
    
    @IBAction func pushToMap(_ sender: Any) {
        debugText.text = ""
        var coordinate: CLLocationCoordinate2D
        
        guard let portfolioURL = portfolioTextField.text, portfolioURL != "" else {
            displayError("Please enter a portfolio domain")
            return
        }
        
        guard let location = locationTextField.text, location != "" else {
            displayError("Please enter your city and state")
            return
        }
        
        geoCoder.geocodeAddressString(location){(placemark, error) in
            guard error == nil else {
                self.displayError("Please enter a valid location")
                return
            }
            
            let coordinate = placemark?.first?.location?.coordinate
            
            
            performUIUpdatesOnMain {
                self.showNewLocation(coordinate!)
            }
        }
    }
    
    private func showNewLocation(_ coordinate:CLLocationCoordinate2D){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewLocationMapController") as! NewLocationMapController
        controller.coordinate = coordinate
        controller.url = portfolioTextField.text
        controller.mapString = locationTextField.text
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugText.text = errorString
        }
    }
    
//    private func configurePlacemarkData(_ placemarks:[CLPlacemark]?) -> CLLocationCoordinate2D {
//
//        var location: CLLocation?
//
//        if let placemarks = placemarks, placemarks.count > 0 {
//            location = placemarks.first?.location
//        }
//
//        let coordinate = location?.coordinate
//        return coordinate!
//    }
}

