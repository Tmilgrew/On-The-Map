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
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        activityIndicator.startAnimating()
        if segue.identifier == "showLocation"{
            let controller = segue.destination as! NewLocationMapController
            
            debugText.text = ""
            
            guard let portfolioURL = portfolioTextField.text, portfolioURL != "" else {
                displayError("Please enter a portfolio domain")
                return
            }
            
            guard let location = locationTextField.text, location != "" else {
                displayError("Please enter your city and state")
                return
            }
            
            controller.location = location
            
            
            
            controller.url = self.portfolioTextField.text
            controller.mapString = self.locationTextField.text
            
        }
        activityIndicator.stopAnimating()
    }
    
    @IBAction func cancel(_ sender: Any) {
        let controller = self.navigationController!.viewControllers[0]
        let _ = self.navigationController?.popToViewController(controller, animated: true)
    }
    
    
    
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugText.text = errorString
        }
    }
}

