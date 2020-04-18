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
    @IBOutlet var dateString: UILabel!
    @IBOutlet var thumnail: UIImageView!
    var pin:Artwork!
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var detailField: UITextView!
    var key:String!
    var detailString: String!
    var locationManager: CLLocationManager?
    var loclist = [Double]()
    var loc:String!
    var date:String!
    var im:UIImage!
    var desc:String!
    var ind:Int!
    let defaults = UserDefaults.standard
    var tableViewController:ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //detailLabel.isUserInteractionEnabled=false
        //detailLabel?.text=detailString
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)); view.addGestureRecognizer(tap)
       
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
        thumnail.image=im
        thumnail.layer.cornerRadius=8.0
        thumnail.transform = thumnail.transform.rotated(by: CGFloat(Double.pi / 2))
        
        dateString.text=date
        detailField.text=desc
        detailField.textColor = UIColor.label
        let savedict=defaults.object(forKey: "TestDict") as? [String: String] ?? [String: String]()
               print(savedict["LostItem1"] ?? "Blah")
        // Do any additional setup after loading the view.
    }
    
    func setMapFocus(location: CLLocationCoordinate2D?, radiusInKm radius: CLLocationDistance) {
        
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location! ,latitudinalMeters: radius,longitudinalMeters: radius)
        self.mapView.setRegion(region, animated: false)
    }
    func addAnnotation(){
        
        let artwork = Artwork(title: "\(detailString ?? "Item")", locationName: "Place", discipline: "Location", coordinate: CLLocationCoordinate2D(latitude: loclist[0] , longitude: loclist[1] ))
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
    @IBAction func claimButton(_ sender: UIButton) {
        var dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
        var logos = defaults.object(forKey: "TestIcons") as? [Data]
        var images = defaults.object(forKey: "TestImages") as? [Data]
        logos?.remove(at: ind)
        images?.remove(at: ind)
        
        print("Index \(ind)")
        dictionary?.removeValue(forKey: key)
        var newDict=[String:Any]()
        var i = 0
        dictionary?.forEach{ key in
            print(key)
            newDict["LostItem\(i+1)"]=key.value
            i=i+1
        }
        dictionary=newDict
        defaults.set(logos,forKey:"TestIcons")
        defaults.set(images,forKey:"TestImages")
        defaults.set(dictionary,forKey: "TestDict")
  
        _ = navigationController?.popViewController(animated: true)
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
