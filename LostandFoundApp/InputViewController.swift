//
//  InputViewController.swift
//  LostandFoundApp
//
//  Created by Aidan O'Brien on 4/4/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//
import Foundation
import UIKit
import MapKit
class InputViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var locField: UITextField!
    @IBOutlet var imagePicked: UIImageView!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var locButton: UIButton!
    @IBOutlet var photoButton2: UIButton!
    @IBOutlet var subButton: UIButton!
    @IBOutlet var detailField: UITextView!
    @IBOutlet var imagePicked2: UIImageView!
    var b1 = false
    var b2 = false
    var loc:String!
    var times=0
    var locationManager: CLLocationManager?
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    var im: UIImage!
    var im2: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)); view.addGestureRecognizer(tap)
        nameField.delegate=self
        locField.delegate=self
        locButton.titleLabel?.textAlignment = .center
        locButton.layer.cornerRadius = 8
        photoButton.layer.cornerRadius = 8
        photoButton2.layer.cornerRadius = 8
        photoButton.titleLabel?.textAlignment = .center
        photoButton2.titleLabel?.textAlignment = .center
        subButton.layer.cornerRadius = 8
        detailField.layer.cornerRadius = 8
        nameField.center.x = self.view.center.x
        locField.center.x = self.view.center.x
        detailField.text="Description"
        detailField.textColor=UIColor.placeholderText
        detailField.layer.borderWidth=1
        detailField.layer.borderColor=UIColor.systemGray3.cgColor
        detailField.delegate=self
        let cdate = Date()
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateStyle = .medium // 2-3
        
        self.dateField.text = dateformatter.string(from: cdate)
        locationManager = CLLocationManager()
        
        
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
           
        }
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
    @IBAction func submitButton(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locField?.text ?? "Blah") { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let defaults = UserDefaults.standard
                    var dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
                    let size = (dictionary?.count ?? 3) as Int
                    let item = ["LostItem\(size+1)":["Name":"\(self.nameField?.text ?? "Blah")","Location":[location.coordinate.latitude,location.coordinate.longitude],"Date":self.dateField.text ?? "Blah","Description":self.detailField.text ?? "Blah"]]
                    dictionary?.merge(item){(current, _) in current}
                    defaults.set(dictionary,forKey:"TestDict")
                    var images=defaults.object(forKey: "TestIcons") as? [Data]
                    let pic:Data
                    if(self.im==nil) {
                        pic = UIImage(named: "pic")!.pngData()!
                        
                    }
                    else {
                        pic = self.im.pngData()!
                    }
                    var dimages=defaults.object(forKey: "TestImages") as? [Data]
                    let pic2:Data
                    if(self.im2==nil) {
                        pic2 = UIImage(named: "pic")!.pngData()!
                    }
                    else {
                        pic2 = self.im2.pngData()!
                    }
                    images?.append(pic)
                    defaults.set(images,forKey:"TestIcons")
                    dimages?.append(pic2)
                    defaults.set(dimages,forKey:"TestImages")
                    print(dictionary!.count)
                    return
                }
                
            }
            else {
                geocoder.geocodeAddressString("Appalachian State University" ?? "Blah") { (placemarks, error) in
                           if error == nil {
                               if let placemark = placemarks?[0] {
                                   let location = placemark.location!
                                   let defaults = UserDefaults.standard
                                   var dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
                                   let size = (dictionary?.count ?? 3) as Int
                                   let item = ["LostItem\(size+1)":["Name":"\(self.nameField?.text ?? "Blah")","Location":[location.coordinate.latitude,location.coordinate.longitude],"Date":self.dateField.text ?? "Blah","Description":self.detailField.text ?? "Blah"]]
                                   dictionary?.merge(item){(current, _) in current}
                                   defaults.set(dictionary,forKey:"TestDict")
                                   var images=defaults.object(forKey: "TestIcons") as? [Data]
                                   let pic:Data
                                   if(self.im==nil) {
                                       pic = UIImage(named: "pic")!.pngData()!
                                   }
                                   else {
                                       pic = self.im.pngData()!
                                   }
                                   var dimages=defaults.object(forKey: "TestImages") as? [Data]
                                   let pic2:Data
                                   if(self.im2==nil) {
                                       pic2 = UIImage(named: "pic")!.pngData()!
                                   }
                                   else {
                                       pic2 = self.im2.pngData()!
                                   }
                                   images?.append(pic)
                                   defaults.set(images,forKey:"TestIcons")
                                   dimages?.append(pic2)
                                   defaults.set(dimages,forKey:"TestImages")
                                   print(dictionary!.count)
                                   return
                               }
                               
                           }
                }
                
            }
                
            
        }
        _ = navigationController?.popViewController(animated: true)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
    
    }
    @objc func keyboardWillHide(notification: NSNotification) { if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
    
        }
        

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailField.textColor == UIColor.placeholderText {
            detailField.text = nil
            detailField.textColor = UIColor.label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if detailField.text.isEmpty {
            detailField.text = "Description"
            detailField.textColor = UIColor.placeholderText
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
   
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if b1 == true {
            imagePicked.image=image
            im = image
                //save image
                //display image
            photoButton.setTitle("Retake Photo", for: .normal)
            b1=false
            self.dismiss(animated: true, completion: nil)
        }
        else if b2 == true {
            imagePicked2.image=image
            im2 = image
                //save image
                //display image
            photoButton2.setTitle("Retake Photo ", for: .normal)
            b2=false
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func photoTake(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if sender.titleLabel?.text == "Add Photo" || sender.titleLabel?.text == "Retake Photo" {
                   imagePicked.layer.cornerRadius = 8.0
                   b1=true
                   let imagePicker = UIImagePickerController()
                   imagePicker.delegate = self
                   imagePicker.sourceType = .camera;
                   imagePicker.allowsEditing = false
                   self.present(imagePicker, animated: true, completion: nil)
                }
            else if sender.titleLabel?.text == "Add Photo " || sender.titleLabel?.text == "Retake Photo "{
                   imagePicked2.layer.cornerRadius = 8.0
                   b2=true
                   let imagePicker = UIImagePickerController()
                   imagePicker.delegate = self
                   imagePicker.sourceType = .camera;
                   imagePicker.allowsEditing = false
                   self.present(imagePicker, animated: true, completion: nil)                }
            }
    }
    @objc func tapDone(_ sender: Any) {
        if let datePicker = self.dateField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.dateField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateField.resignFirstResponder() // 2-5
    }
    @IBAction func fillLocation(_ sender: UIButton) {
      
        self.locationManager?.startUpdatingLocation()
        
        
     
        
    }
    @IBAction func descInfo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Item Description", message: "Here you can input a desiption for the item, such as color or size.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        

        self.present(alert, animated: true)
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
                    self.locField.text=self.loc
                    self.locationManager?.stopUpdatingLocation()
                }
                else {
                 // An error occurred during geocoding.
                    self.loc="Appalachian State University"
                    self.locField.text=self.loc
                    self.locationManager?.stopUpdatingLocation()
                }
            })
        }
    }
    @IBAction func photoDesc1(_ sender: UIButton) {
        let alert = UIAlertController(title: "Item Photo", message: "For this photo, take a close up picture of the item. Try to get as many identifying features as possible in the frame to help the user identify the item.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        

        self.present(alert, animated: true)
    }
    @IBAction func photoDesc2(_ sender: UIButton) {
        let alert = UIAlertController(title: "Detailed Photo", message: "For this photo, take wide shot of the item in it's environment. Try to get as of the surrounding area as possible in the frame to the user recognize where it is being left.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
   
}
