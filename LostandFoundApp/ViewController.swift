//
//  ViewController.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 2/23/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var pressed=false
    var selectedItem=""
    var selectedRow:Int!
    var firstLocation=""
    var table=[[String(),String()]]
   
    let defaults = UserDefaults.standard
    var petArray = [["Mammal", "cat", "dog", "hamster", "gerbil", "rabbit"], ["Bird", "parakeet", "parrot", "canary", "finch"], ["Fish", "tropical fish", "goldfish", "sea horses"], ["Reptile", "turtle", "snake", "lizard"]]
    var testNames = [String]()
    var testDates = [String]()
    var testDesc = [String]()
    var testDetails = [[Double]]()
    var toRemove:Int!
    @IBOutlet var petTable: UITableView!
    @IBOutlet var eButton: UIBarButtonItem!
    var isLoadedFirstTime = false
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDefault()
        // Do any additional setup after loading the view.
        let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
        let size = (dictionary?.count ?? 3) as Int
        for i in 1...size {
            let array = dictionary?["LostItem\(i)"] as? [String:Any]
            let val = array?["Name"] ?? "Blah"
            let date = array?["Date"] ?? "Blah"
            let desc = array?["Description"] ?? "Blah"
            testNames.append(val as! String)
            testDates.append(date as! String)
            testDesc.append(desc as! String)
            let loc = array?["Location"]
            
            testDetails.append(loc as! [Double])
           
        }
        
        isLoadedFirstTime = true
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        if !isLoadedFirstTime {
            
            super.viewDidAppear(animated)
            let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
            
            let size = (dictionary?.count ?? 3) as Int
         
            if size < testNames.count {
                
                testNames.remove(at: self.toRemove)
                testDates.remove(at: self.toRemove)
                testDesc.remove(at: self.toRemove)
                testDetails.remove(at: self.toRemove)
                
                petTable.reloadData()
            }
            else
            {
                if size != 0 {
                    for i in 0...size-1 {
                        if i < size-1 || size == testNames.count {
                          
                            continue
                        }
                        else {
                            
                            let array = dictionary?["LostItem\(i+1)"] as? [String:Any]
                            
                            let val = array?["Name"] ?? "Blah"
                            let date = array?["Date"] ?? "Blah"
                            let desc = array?["Description"] ?? "Blah"
                           
                            testNames.append(val as! String)
                            testDates.append(date as! String)
                            testDesc.append(desc as! String)
                            let loc = array?["Location"]
                            
                            testDetails.append(loc as! [Double])
                         
                        }
                        petTable.reloadData()
                    }
                }
            }
            
        }
        isLoadedFirstTime = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testNames.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! TableViewCell
        
        cell.titleLabel?.text=testNames[indexPath.row]
        
        
        
        let images=defaults.object(forKey: "TestIcons") as! [Data]
        
        let thumb = UIImage(data: images[indexPath.row])
        
        let image = UIImage(cgImage: (thumb?.cgImage)!, scale: CGFloat(1.0), orientation: .right)
        cell.thumbnail.image=image
        cell.detailLabel?.text=testDates[indexPath.row]
        cell.thumbnail.layer.cornerRadius=8.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = testNames[indexPath.row]
        selectedRow=indexPath.row
        performSegue(withIdentifier: "detailLink", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="detailLink"{
            let nextVC = segue.destination as! DetailViewController
            self.toRemove=selectedRow
            nextVC.navigationItem.title = "\(selectedItem) Details"
            nextVC.key="LostItem\(selectedRow+1)"
            nextVC.detailString="\(selectedItem)"
            nextVC.loclist=testDetails[selectedRow]
            nextVC.date=testDates[selectedRow]
            nextVC.desc=testDesc[selectedRow]
            nextVC.ind=selectedRow
            let images=defaults.object(forKey: "TestIcons") as! [Data]
            
            let thumb = UIImage(data: images[selectedRow])
            nextVC.im=thumb
            let images2=defaults.object(forKey: "TestImages") as! [Data]
            
            let thumb2 = UIImage(data: images2[selectedRow])
            nextVC.im2=thumb2
        }
        
    }

    
    
    
    func displayAlert(section:Int, location: Int) {
        let alert = UIAlertController(title: "Add", message: "New Pet", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Pet type here"
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            let savedText = alert.textFields![0] as UITextField
            self.petArray[section].insert(savedText.text ?? "default", at: location)
            self.petTable.reloadData()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true, completion: nil)
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "inputLink", sender: self)
        
    }
    
    func makeDefault(){
        let image = UIImage(named:"pic")
        let imageData = (image?.pngData())
        let icon = UIImage(named:"pic")
        let iconData = (icon?.pngData())
        var logoImages = [Data]()
        var detImages = [Data]()
        for i in 0...2 {
            logoImages.append(iconData!)
            detImages.append(imageData!)
        }
        let dict = ["LostItem1":["Name":"Wallet","Location":[35.136802,-80.824279],"Date":"April 11, 2020","Description":""],
                    "LostItem2":["Name":"Phone","Location":[35.136399,-80.824924],"Date":"April 11, 2020","Description":""],
                    "LostItem3":["Name":"Keys","Location":[35.136399,-80.818847],"Date":"April 11, 2020","Description":""]]
        defaults.set(logoImages,forKey:"TestIcons")
        defaults.set(detImages,forKey:"TestImages")
        defaults.set(dict,forKey: "TestDict")
    }
    
}

