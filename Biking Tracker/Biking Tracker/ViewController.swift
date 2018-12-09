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
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate ,MKMapViewDelegate {
var timer = Timer()
var totalTime : Int = 0
var running : Bool = false;
      var annotationStartPoint : Int  = -1
    @IBOutlet weak var startTracking: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var clearMap: UIButton!
    @IBOutlet weak var durationHolder: UILabel!
    @IBOutlet weak var startTimeHolder: UILabel!
    @IBOutlet weak var stopTracking: UIButton!
    var locationManager = CLLocationManager()
    var road: [MKCircle] = []
    var roadAnnotations: [BikeAnnotation] = []

    
    @IBAction func startTrackingclick(_ sender: UIButton) {
        self.annotationStartPoint = self.road.count
        print("initial array :\(self.annotationStartPoint)")
        if (running == false) {
            totalTime = 0
            durationHolder.text = ""
            running = true;
            //startTracking.setImage(UIImage(named: "stopicon.png"), for: .normal)
           
            print("start biking")
            startTimeHolder.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
            
            locationManager.startUpdatingLocation()
            addPoint((locationManager.location?.coordinate)!, "start")
          
            
            
        }
    }

    func addPoint(_ coor:CLLocationCoordinate2D, _ title : String){
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        let instanceCoordinate = CLLocationCoordinate2D(latitude: coor.latitude, longitude: coor.longitude)
        let instanceAnnotation = BikeAnnotation(coordinate: instanceCoordinate, title: title, subtitle: "")
        roadAnnotations.append(instanceAnnotation)
        
        self.mapView.addAnnotation(instanceAnnotation)
    }
    
    @IBAction func stopTrackingClick(_ sender: UIButton) {
        if (running == true) {
            locationManager.stopUpdatingLocation()
            timer.invalidate()
            running = false
            //startTracking.setImage(UIImage(named: "starticon.png"), for: .normal)
            addPoint((self.locationManager.location?.coordinate)!,"stop")
        }
        
    }
    @IBAction func clearMapClicked(_ sender: Any) {
        
        self.mapView.removeOverlays(self.road)
        self.road = []
        
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
        if (running == true){
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) )
        
            self.mapView.setRegion(region, animated: false)
            self.road.append(MKCircle(center: region.center , radius: 2))
            self.mapView.addOverlays(self.road, level: .aboveLabels)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1.0
        return circleRenderer
        
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        
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


