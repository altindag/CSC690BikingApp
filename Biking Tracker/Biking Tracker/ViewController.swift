//
//  ViewController.swift
//  Biking Tracker
//
//  Created by Soheil on 11/29/18.
//  Copyright © 2018 sohe1l. All rights reserved.
//

import UIKit
import MapKit

class BikeAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
    
    var region: MKCoordinateRegion{
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}
class ViewController: UIViewController {
var timer = Timer()
var totalTime : Int = 0
var running : Bool = false;
    @IBOutlet weak var startTracking: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var durationHolder: UILabel!
    @IBOutlet weak var startTimeHolder: UILabel!


    
    @IBAction func startTrackingclick(_ sender: UIButton) {
        
        if (running == false) {
            totalTime = 0
            durationHolder.text = ""
            running = true;
            startTracking.setImage(UIImage(named: "stopicon.png"), for: .normal)
           
            print("start biking")
            startTimeHolder.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            let instanceCoordinate = CLLocationCoordinate2D(latitude: 42.361, longitude: -71.0942)
            let instanceAnnotation = BikeAnnotation(coordinate: instanceCoordinate, title: "start location", subtitle: "we started here")
            mapView.addAnnotation(instanceAnnotation)
            mapView.setRegion(instanceAnnotation.region, animated: true)
            
        }else{
            timer.invalidate()
            running = false
            startTracking.setImage(UIImage(named: "starticon.png"), for: .normal)

            
        }
    }
    @IBAction func startTracking(_ sender: UIButton) {
        

    }
    func updateTime() {
       
         totalTime += 1
        let seconds: Int = totalTime % 60
        let minutes: Int = (totalTime / 60) % 60
        let hours: Int = totalTime / 3600

        durationHolder.text = "\(hours) : \((minutes)) : \(seconds)"
        
      
        
       
    }

    @objc func tick() {
       
        updateTime()
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if let bikeAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            bikeAnnotation.animatesWhenAdded = true
            bikeAnnotation.titleVisibility = .adaptive
            bikeAnnotation.titleVisibility = .adaptive
            
            return bikeAnnotation
        }
        return nil
    }
}
