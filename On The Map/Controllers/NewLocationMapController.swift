//
//  NewLocationMapController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 12/6/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import MapKit

class NewLocationMapController: UIViewController, MKMapViewDelegate {
    var newStudent: ParseStudent!
    var coordinate: CLLocationCoordinate2D!
    var url: String!
    var mapString: String!
    var studentAnnotation = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.sharedInstance().getUserInfo() {(results, error) in
            print(results)
            
            self.newStudent = ParseStudent(dictionary: results)
            //print(self.newStudent)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.coordinate
            annotation.title = "\(self.newStudent.firstName as! String) \(self.newStudent.lastName as! String)"
            annotation.subtitle = self.url
            
            self.studentAnnotation.append(annotation)
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(self.studentAnnotation)
            }
            
        }
        
        
    }
    
    @IBAction func addLocation(_ sender: Any) {
        newStudent.latitude = coordinate.latitude as Double
        newStudent.longitude = coordinate.longitude as Double
        newStudent.mediaURL = url
        newStudent.mapString = mapString
        print(newStudent)
        ParseClient.sharedInstance().postStudentLocation(newStudent) { (results, error) in
            
            self.newStudent.objectID = results!["objectId"] as? String
            performUIUpdatesOnMain {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        
        //post new location and then return to main screen.  call refresh
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string:toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
