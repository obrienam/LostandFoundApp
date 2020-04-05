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
class InputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var locField: UITextField!
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)); view.addGestureRecognizer(tap)
        nameField.delegate=self
        locField.delegate=self
        
        
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
                    let item = ["LostItem\(size+1)":["Name":"\(self.nameField?.text ?? "Blah")","Location":[location.coordinate.latitude,location.coordinate.longitude]]]
                    dictionary?.merge(item){(current, _) in current}
                    defaults.set(dictionary,forKey:"TestDict")
                    
                    return
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    func writePlistFile(withData data: NSDictionary, atPath path: String) -> Bool {
       
       
            let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let customPlistURL = docsBaseURL.appendingPathComponent("Datatest.plist")
            return NSDictionary(dictionary: data).write(to: customPlistURL, atomically: true)
            

            

        
        
       
       
        
            
        
        
        
        //return data.write(toFile: Bundle.main.path(forResource: "Datatest", ofType: "plist") ?? "none", atomically: false)
        

        
    }
    func readPlistFile(atPath path: String) -> [String : Any] {
        var plistData: [String : Any] = [:]
        
        guard let plistFileData = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Datatest", ofType: "plist")!) else {
            print("File doesn't exist")
            return plistData
        }

        
            plistData = plistFileData as! [String : Any]
     
        
            
        

        return plistData
    }
    
}
