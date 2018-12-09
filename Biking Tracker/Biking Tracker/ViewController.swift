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
class ViewController: UIViewController, CLLocationManagerDelegate ,MKMapViewDelegate {
var timer = Timer()
var totalTime : Int = 0
var running : Bool = false;
    @IBOutlet weak var startTracking: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var durationHolder: UILabel!
    @IBOutlet weak var startTimeHolder: UILabel!
 var locationManager = CLLocationManager()
    var road: [MKCircle] = []

    
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
            locationManager.startUpdatingLocation()
            
        }else{
            locationManager.stopUpdatingLocation()
            timer.invalidate()
            running = false
            startTracking.setImage(UIImage(named: "starticon.png"), for: .normal)

            
        }
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) )
        
        self.mapView.setRegion(region, animated: false)
        print(locations[0].coordinate.latitude)
        print(locations.count)
        
        self.road.append(MKCircle(center: region.center , radius: 2))
        self.mapView.addOverlays(self.road, level: .aboveLabels)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1.0
        print("overlay")
        return circleRenderer
        
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.followWithHeading, animated: false)
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                
                locationManager.requestWhenInUseAuthorization()
                
            }
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            
            
            
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}


