import UIKit
import MapKit

class HistoryItemController: UIViewController, MKMapViewDelegate{

    var selectedID = 0

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        mapView.delegate = self

        
        let path = PathList.shared.getList()[selectedID]
  
        print(path.title)
        print(path.lats)
        
    

        // build the points
        var road: [MKCircle] = []
        
        
        for i in 0...path.lats.count - 1 {
            
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: path.lats[i], longitude: path.lngs[i]), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) )
            
            self.mapView.setRegion(region, animated: false)
            road.append(MKCircle(center: region.center , radius: 2))
            
            
            self.mapView.addOverlays(road, level: .aboveLabels)

        }
        


    





    
        
        
        
        
        
//        mapView.delegate = self
//        mapView.showsUserLocation = true
        
//        if CLLocationManager.locationServicesEnabled() == true {
//            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
//
//                locationManager.requestWhenInUseAuthorization()
//
//            }
//            locationManager.desiredAccuracy = 1.0
//            locationManager.delegate = self
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1.0
        return circleRenderer
        
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
    
    
    
    
}
