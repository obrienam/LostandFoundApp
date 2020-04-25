//
//  MapViewController.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 3/21/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

   
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
    var toRemove=0
    var temp=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation=true
        self.mapView.delegate=self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate=self
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
        if size != 0 {
            for i in 0...size-1 {
                let array = dictionary?["LostItem\(i+1)"] as? [String:Any]
                let val = array?["Name"] ?? "Blah"
                testNames.append(val as! String)
                let loc = array?["Location"]
                
                testDetails.append(loc as! [Double])
                
            }
            addAnnotations()
        }
        isLoadedFirstTime=true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isLoadedFirstTime {
            let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
            let size = (dictionary?.count ?? 3) as Int
            
            if size < testNames.count{
                print("blah")
                testNames=[]
                testDetails=[]
                mapView.removeAnnotations(pins)
                if size != 0
                {
                    for i in 0...size-1 {
                   
                        let array = dictionary?["LostItem\(i+1)"] as? [String:Any]
                        let val = array?["Name"] ?? "Blah"
                        testNames.append(val as! String)
                        let loc = array?["Location"]
                        
                        testDetails.append(loc as! [Double])
                        
                        
                    }
                    addAnnotations()
                }
            }
            if size > testNames.count{
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
            let geocoder = CLGeocoder()
            var location:CLPlacemark?
            
            let lastLocation=CLLocation(latitude: testDetails[i][0], longitude: testDetails[i][1])
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    location = placemarks?[0]
                    let artwork = Artwork(title: "\(self.testNames[i])", locationName: "\(location?.name ?? "location")", discipline: "Location", coordinate: CLLocationCoordinate2D(latitude: self.testDetails[i][0], longitude: self.testDetails[i][1]))
                    
                    self.pins.append(artwork)
                    self.mapView.addAnnotation(artwork)
                }
                else {
                 // An error occurred during geocoding.
                   location = nil
                    location = placemarks?[0]
                    let artwork = Artwork(title: "\(self.testNames[i])", locationName: "\(location?.name ?? "location")", discipline: "Location", coordinate: CLLocationCoordinate2D(latitude: self.testDetails[i][0], longitude: self.testDetails[i][1]))
                    
                    self.pins.append(artwork)
                    self.mapView.addAnnotation(artwork)
                }
            })
            
            
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alert = UIAlertController(title: "Open Map?", message: "Do you want to open walking directions to the item in Apple Maps?", preferredStyle: .alert)
        
        
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action -> Void in
            
            guard let artwork = view.annotation as? Artwork else {
                  return
              }
           
            let launchOptions = [
              MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
            ]
            artwork.mapItem?.openInMaps(launchOptions: launchOptions)
            
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { action -> Void in
            
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert,animated: true, completion: nil)
        
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
