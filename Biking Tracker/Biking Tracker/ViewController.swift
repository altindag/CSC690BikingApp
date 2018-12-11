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
    
    var path : Path? = nil
    
    var roadAnnotations: [BikeAnnotation] = []

    
    @IBAction func startTrackingclick(_ sender: UIButton) {
    
        path = Path()
        
        
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
            
            // save -- TODO unwrap
            if let p = path{
                PathList.shared.add(p)
            }
        }
    }
    @IBAction func clearMapClicked(_ sender: Any) {
       
        let coordinate : MKCircle =  self.road[self.road.count-1]
        self.mapView.removeAnnotations(self.roadAnnotations)
        self.mapView.removeOverlays(self.road)
        self.road = []
        
        
        if running == false{
            startTimeHolder.text = "0 : 0"
            durationHolder.text = "0 : 0 : 0"
            totalTime = 0;
        }else{
            startTimeHolder.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            totalTime = 0;
            
            
            addPoint((coordinate.coordinate), "stop")
            
        }
        
        self.road.append(coordinate)
       // self.mapView.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
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
            
            
//            print(locations[0].coordinate.latitude)
//            print(locations[0].coordinate.longitude)
            
            path?.lats.append(locations[0].coordinate.latitude)
            path?.lngs.append(locations[0].coordinate.longitude)
            
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "point.png")
        }
        
        return annotationView
    }
    
    
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        var filePath: String {
            //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
            let manager = FileManager.default
            //2 - this returns an array of urls from our documentDirectory and we take the first path
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            print("this is the url path in the documentDirectory \(url)")
            //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
            return (url!.appendingPathComponent("Data").path)
        }

        var fileURL: URL {
            //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
            let manager = FileManager.default
            //2 - this returns an array of urls from our documentDirectory and we take the first path
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            print("this is the url path in the documentDirectory \(url)")
            //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
            return (url!.appendingPathComponent("Data"))
        }
        
//
//        let encoder = JSONEncoder()
//        let encoded = try! encoder.encode(path)
        
        
        
        if let encodedData = try? JSONEncoder().encode(path) {
            do {
                try encodedData.write(to: fileURL)
            }
            catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func loadBtn(_ sender: Any) {
        
        
        
        var fileURL: URL {
            //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
            let manager = FileManager.default
            //2 - this returns an array of urls from our documentDirectory and we take the first path
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            print("this is the url path in the documentDirectory \(url)")
            //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
            return (url!.appendingPathComponent("Data"))
        }
        
        
        do {
            let text2 = try Data(contentsOf: fileURL)
            
            print(text2)
            
            
            let decoder = JSONDecoder()
            guard let loadedPath = try? decoder.decode(Path.self, from: text2) else{
                return
            }
            print(loadedPath.title)
        }
        catch {/* error handling here */}
        
        
        
    }
    

}


