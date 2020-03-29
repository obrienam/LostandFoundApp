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
    var firstLocation=""
    var petArray = [["Mammal", "cat", "dog", "hamster", "gerbil", "rabbit"], ["Bird", "parakeet", "parrot", "canary", "finch"], ["Fish", "tropical fish", "goldfish", "sea horses"], ["Reptile", "turtle", "snake", "lizard"]]
    @IBOutlet var petTable: UITableView!
    @IBOutlet var eButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        petTable.setEditing(!petTable.isEditing, animated: true)
        if petTable.isEditing == true{
            eButton.title="Done"
        }
        else{
            eButton.title="Edit"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petArray[section].count-1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if (cell==nil) {
            cell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text=petArray[indexPath.section][indexPath.row + 1]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = petArray[indexPath.section][indexPath.row + 1]
        performSegue(withIdentifier: "detailLink", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DetailViewController
        nextVC.navigationItem.title = "\(selectedItem) Details"
        nextVC.detailString="You selected a \(selectedItem) as your pet"
        nextVC.animal="\(selectedItem)"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return petArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return petArray[section][0]
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = petArray[sourceIndexPath.section][sourceIndexPath.row + 1]
        petArray[sourceIndexPath.section].remove(at: sourceIndexPath.row + 1)
        petArray[sourceIndexPath.section].insert(movedObject, at: destinationIndexPath.row + 1)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
            self.petArray[indexPath.section].remove(at: indexPath.row+1)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        let swipeAction=UISwipeActionsConfiguration(actions:[deleteAction])
        return swipeAction
    }
    
}

