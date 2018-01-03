//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/25/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit

class StudentListViewController: UIViewController{
    
    //var students:[ParseStudent] = [ParseStudent]()
    @IBOutlet weak var studentTableView: UITableView!
    var students = Storage.students

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentTableView.delegate = self
        studentTableView.dataSource = self
        
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
                performUIUpdatesOnMain {
                    self.studentTableView!.reloadData()
                    self.studentTableView.layoutIfNeeded()
                    self.studentTableView!.setContentOffset(.zero, animated: true)
                }
            }else{
                print (error ?? "empty error")
            }
        }
            /*
             
             
             3) implement the delegate for listview
             4) call reload data in performUpdates on main call
            */
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.studentTableView.reloadData()
    }
    
    func refresh(){
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
                performUIUpdatesOnMain {
                    self.studentTableView!.reloadData()
                }
            }else{
                print (error ?? "empty error")
            }
        }
    }
}

extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        if let fName = student.firstName, let lName = student.lastName{
            cell?.textLabel!.text = "\(fName) \(lName)"
        } else {
            cell?.textLabel!.text = "No User Name :("
        }
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        if let urlString = student.mediaURL{
            cell?.detailTextLabel?.text = "\(urlString)"
        } else {
            cell?.detailTextLabel?.text = "No Media URL :("
        }
        
        return cell!
        
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        print(students.count)
        return students.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let string = students[indexPath.row].mediaURL, let url = URL(string: string) {
            let request = URLRequest(url: url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
}




    

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    

    
    

