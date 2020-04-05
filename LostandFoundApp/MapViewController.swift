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
    var loclist:NSArray!
    var testNames = [String]()
    var testDetails = [[Double]]()
    var pins=[Artwork]()
    let defaults = UserDefaults.standard
    var isLoadedFirstTime = false
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
        
        setMapFocus(location: userLocation, radiusInKm: 500)
        let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
        let size = (dictionary?.count ?? 3) as Int
        for i in 0...size-1 {
            let array = dictionary?["LostItem\(i+1)"] as? [String:Any]
            let val = array?["Name"] ?? "Blah"
            testNames.append(val as! String)
            let loc = array?["Location"]
            
            testDetails.append(loc as! [Double])
            
        }
        addAnnotations()
        isLoadedFirstTime=true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isLoadedFirstTime {
            
            let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
            let size = (dictionary?.count ?? 3) as Int
            if size > testNames.count {
                mapView.removeAnnotations(pins)
                for i in 0...size-1 {
                    if i < size-1 {
                        continue
                    }
                    else {
                        let array = dictionary?["LostItem\(i+1)"] as? [String:Any]
                        let val = array?["Name"] ?? "Blah"
                        testNames.append(val as! String)
                        let loc = array?["Location"]
                        
                        testDetails.append(loc as! [Double])
                        print(testDetails[i-1])
                    }
                }
                addAnnotations()
            }
        }
        isLoadedFirstTime=false
    }
    func setMapFocus(location: CLLocationCoordinate2D?, radiusInKm radius: CLLocationDistance) {
        
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location! ,latitudinalMeters: radius,longitudinalMeters: radius)
        self.mapView.setRegion(region, animated: false)
    }
    func addAnnotations() {
        for i in 0...testNames.count-1 {
            let artwork = Artwork(title: "\(testNames[i])", locationName: "Place", discipline: "Location", coordinate: CLLocationCoordinate2D(latitude: testDetails[i][0], longitude: testDetails[i][1]))
            pins.append(artwork)
            self.mapView.addAnnotation(artwork)
        }
    }
    /*
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
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
