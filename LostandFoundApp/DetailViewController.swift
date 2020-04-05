//
//  DetailViewController.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 3/2/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class DetailViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet var btnText: UIBarButtonItem!
    var animal="placeholder"
    var pin:Artwork!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var itemName: UILabel!
    var detailString: String!
    var locationManager: CLLocationManager?
    var loclist = [Double]()
    var loc:String!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //detailLabel.isUserInteractionEnabled=false
        //detailLabel?.text=detailString
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)); view.addGestureRecognizer(tap)
        itemName.text=detailString
        locationManager = CLLocationManager()
        
        
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
            let itemLocation = CLLocationCoordinate2D(latitude: loclist[0] , longitude: loclist[1])
            
            setMapFocus(location: itemLocation, radiusInKm: 100)
            addAnnotation()
        }
        let savedict=defaults.object(forKey: "TestDict") as? [String: String] ?? [String: String]()
               print(savedict["LostItem1"] ?? "Blah")
        // Do any additional setup after loading the view.
    }
    
    func setMapFocus(location: CLLocationCoordinate2D?, radiusInKm radius: CLLocationDistance) {
        
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location! ,latitudinalMeters: radius,longitudinalMeters: radius)
        self.mapView.setRegion(region, animated: false)
    }
    func addAnnotation(){
        
        let artwork = Artwork(title: "\(itemName.text ?? "Item")", locationName: "Place", discipline: "Location", coordinate: CLLocationCoordinate2D(latitude: loclist[0] as! CLLocationDegrees, longitude: loclist[1] as! CLLocationDegrees))
        pin=artwork
        self.mapView.addAnnotation(artwork)
        
        
    }
    /*
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if detailLabel.isUserInteractionEnabled{
        detailLabel.isUserInteractionEnabled=false
        btnText.title="Edit"
        }
        else{
        detailLabel.isUserInteractionEnabled=true
        btnText.title="Done"
        }
        
    }
    
    @IBAction func showAlert(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Location", message: "Your current location is \(loc ?? "Nil")", preferredStyle: .alert)
        
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            
            
        })
        
        alert.addAction(okAction)
       
        self.present(alert,animated: true, completion: nil)
    }
 */
    func convertLoc(location: CLPlacemark?) -> String?{
        return location?.name
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(location,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    self.loc=firstLocation?.name
                }
                else {
                 // An error occurred during geocoding.
                    self.loc="None"
                }
            })
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
    
    }
    @objc func keyboardWillHide(notification: NSNotification) { if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
    
        }
        

    }
    
    
}
