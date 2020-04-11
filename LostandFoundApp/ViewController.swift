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
    var testDetails = [[Double]]()
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
            testNames.append(val as! String)
            let loc = array?["Location"]
            
            testDetails.append(loc as! [Double])
            print(testDetails[i-1])
        }
        isLoadedFirstTime = true
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        if !isLoadedFirstTime {
            super.viewDidAppear(animated)
            let dictionary = defaults.object(forKey: "TestDict") as? [String:Any]
            let size = (dictionary?.count ?? 3) as Int
            for i in 0...size-1 {
                if i < size-1 || size == testNames.count {
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
                petTable.reloadData()
            }
            
        }
        isLoadedFirstTime = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testNames.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if (cell==nil) {
            cell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text=testNames[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = testNames[indexPath.row]
        selectedRow=indexPath.row
        performSegue(withIdentifier: "detailLink", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="detailLink"{
            let nextVC = segue.destination as! DetailViewController
            
            nextVC.navigationItem.title = "\(selectedItem) Details"
            nextVC.detailString="\(selectedItem)"
            nextVC.loclist=testDetails[selectedRow]
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title: "Add"){ (contextualAction,view,boolValue) in
            self.displayAlert(section: indexPath.section,location: indexPath.row+1) }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [addAction])
                
        
        return swipeAction
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            (contextualAction,view,boolValue) in
            self.petArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        let swipeAction=UISwipeActionsConfiguration(actions:[deleteAction])
        return swipeAction
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "inputLink", sender: self)
        
    }
    
    func makeDefault(){
        var image = UIImage(named:"icon")
        let dict = ["LostItem1":["Name":"Wallet","Location":[35.136802,-80.824279]],
                    "LostItem2":["Name":"Phone","Location":[35.136399,-80.824924]],
                    "LostItem3":["Name":"Keys","Location":[35.136399,-80.818847]]]
        defaults.set(dict,forKey: "TestDict")
    }
    
}

