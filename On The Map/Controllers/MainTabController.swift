//
//  MainTabController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 12/2/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    var students = Storage.students
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func refresh(){
        activityIndicator.startAnimating()
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
            } else {
                print("There was an error refreshing.")
            }
        }
        (self.viewControllers![0] as! StudentListViewController).refresh()
        (self.viewControllers![1] as! StudentMapViewController).refresh()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func refresh(sender: UIButton){
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
            } else {
                print("There was an error refreshing.")
            }
        }
        (self.viewControllers![0] as! StudentListViewController).refresh()
        (self.viewControllers![1] as! StudentMapViewController).refresh()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().deleteSession { (results, errorString) in

//            if let error = errorString {
//                self.displayError("\(error)")
//            }else{
//                performUIUpdatesOnMain {
//                    
//                    self.activityIndicator.stopAnimating()
//                }
//            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func displayError(_ error: String?) {
        
        if let errorString = error {
            performUIUpdatesOnMain {
                //self.debugTextLabel.text = String(errorString)
                self.activityIndicator.stopAnimating()
            }
        } else {
            performUIUpdatesOnMain {
                //self.debugTextLabel.text = "unknown error"
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
