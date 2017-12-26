//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/25/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentMapViewController : UIViewController, MKMapViewDelegate {
    
    //var students:[ParseStudent] = [ParseStudent]()
    @IBOutlet weak var mapView: MKMapView!
    var students = Storage.students
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ParseClient.sharedInstance().getMultipleStudents(){ (result, error) in
            if let results = result {
                self.students = results
                performUIUpdatesOnMain {
                    self.refresh()
                }
            }else{
                print (error ?? "empty error")
            }
        }
    }
    
    func refresh() {
        
        if (self.viewIfLoaded == nil){
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        
        
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            if (student.hasNilValues() == false){
                let lat = CLLocationDegrees(student.latitude as! Double)
                let long = CLLocationDegrees(student.longitude as! Double)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.title = "\(student.firstName as! String) \(student.lastName as! String)"
                annotation.subtitle = student.mediaURL
                
                annotations.append(annotation)
            }
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("we here")
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
                //app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    
    
    
    
}
