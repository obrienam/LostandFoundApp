//
//  MapViewController.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 3/21/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController{

   
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    var loc:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation=true
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let userLocation = locationManager.location?.coordinate
        
        setMapFocus(location: userLocation, radiusInKm: 250)
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setMapFocus(location: CLLocationCoordinate2D?, radiusInKm radius: CLLocationDistance) {
        
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location! ,latitudinalMeters: radius,longitudinalMeters: radius)
        self.mapView.setRegion(region, animated: false)
    }
    
    @IBAction func longDetected(_ sender: UILongPressGestureRecognizer) {
        
        
        let position = mapView.convert(sender.location(in: nil),toCoordinateFrom: mapView)
        let center = CLLocation(latitude: position.latitude, longitude: position.longitude)
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        
            
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(center,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    let artwork = Artwork(title: "\(firstLocation?.name ?? "Nil")",
                      locationName: "\(firstLocation?.name ?? "Nil")",
                      discipline: "Building",
                      coordinate: CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude))
                    
                    self.mapView.addAnnotation(artwork)
                }
                else {
                 // An error occurred during geocoding.
                    print("Error")
                }
            })
        
            
         
        
        
        
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
