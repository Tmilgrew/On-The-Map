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
    

    
    @IBAction func refresh(sender: UIButton){
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
                (self.viewControllers![0] as! StudentListViewController).refresh()
                (self.viewControllers![1] as! StudentMapViewController).refresh()
            } else {
                print("There was an error refreshing.")
                let alertController = UIAlertController(title: "On The Map Alert", message: "Could not refresh feed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
//        (self.viewControllers![0] as! StudentListViewController).refresh()
//        (self.viewControllers![1] as! StudentMapViewController).refresh()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().deleteSession { (results, errorString) in


        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
