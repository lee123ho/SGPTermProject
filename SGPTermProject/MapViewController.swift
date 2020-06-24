//
//  MapViewController.swift
//  HospitalMap
//
//  Created by KPU_GAME on 2020/05/18.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var posts = NSMutableArray()
    
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var parks : [Park] = []
    
    func loadInitialData() {
        for post in posts {
            let PARK_NM = (post as AnyObject).value(forKey: "PARK_NM") as! NSString as String
            let REFINE_LOTNO_ADDR = (post as AnyObject).value(forKey: "REFINE_LOTNO_ADDR") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "REFINE_WGS84_LOGT") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "REFINE_WGS84_LAT") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            let park = Park(title: PARK_NM, locationName: REFINE_LOTNO_ADDR, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            parks.append(park)
        }
        let setLocation = CLLocation(latitude: parks[0].coordinate.latitude, longitude: parks[0].coordinate.longitude)
        centerMapOnLocation(location: setLocation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let location = view.annotation as! Park
        let launchOPtions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOPtions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? Park else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: -5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 37.5384514, longitude: 127.0709764)
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(parks)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
