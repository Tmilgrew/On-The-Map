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
    var location: String!
    var studentAnnotation = [MKPointAnnotation]()
    var geoCoder = CLGeocoder()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var debugTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        geoCoder.geocodeAddressString(location){(placemark, error) in
            guard error == nil else {
                self.displayError("Please enter a valid location")
                return
            }
            
            let coordinate = placemark?.first?.location?.coordinate
            self.coordinate = coordinate
            
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
                    self.activityIndicator.stopAnimating()
                }
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
            
            if error != nil {
                self.displayError("\(error?.localizedDescription)")
            }
            self.newStudent.objectID = results!["objectId"] as? String
            performUIUpdatesOnMain {
                
                let controller = self.navigationController!.viewControllers[0]
                let _ = self.navigationController?.popToViewController(controller, animated: true)
                
            }
            
        }
        
        //post new location and then return to main screen.  call refresh
    }
    
    private func displayError(_ error: String?) {
        if let errorString = error {
            debugTextField.text = errorString
        } else {
            debugTextField.text = "unkown error"
        }
    }
    
    
    
    @IBAction func cancel(_ sender: Any) {
        let controller = self.navigationController!.viewControllers[0]
        let _ = self.navigationController?.popToViewController(controller, animated: true)
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
