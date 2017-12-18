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
        
        cell?.textLabel!.text = "\(student.firstName as! String) \(student.lastName as! String)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        cell?.detailTextLabel?.text = "\(student.mediaURL as! String)"
        print(student.uniqueKey)
        
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
    

    
    

