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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func refresh(){
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
    
    @IBAction func showNewLocationSetup(sender: UIButton){
        let storyboard = self.storyboard
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewLocationController") as! NewLocationController
        
        self.present(controller, animated: true, completion: nil)
    }
    
}
