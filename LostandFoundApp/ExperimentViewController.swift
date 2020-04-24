//
//  ExperimentViewController.swift
//  LostandFoundApp
//
//  Created by Aidan O'Brien on 3/29/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit
import QuickLook
struct languages: Codable {
    let Vue: Int
    let HTML: Int
    let JavaScript: Int
}


class ExperimentViewController: UIViewController, QLPreviewControllerDataSource {
    @IBOutlet var tableview: UITableView!
    lazy var previewItem=NSURL()
    var langs:languages!
    var langtable=[[String(),String()]]
    /*
    var plistURL : URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("../../../Users/aidanobrien/Documents/GitHub/LostandFoundApp/LostandFoundApp/Datatest.plist")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let data = dictionary?["Item1"] as! NSArray
        let item = data[0] as! String
        let loc = data[1] as! NSArray
        print("\(loc[0])")
        
        do {
            let dictionary = ["key1" : "value1", "key2":"value2", "key3":"value3"]
            try savePropertyList(dictionary)
        } catch {
            print(error)
        }
        do {
            var dictionary = try loadPropertyList()
            dictionary.updateValue("value4", forKey: "key4")
            try savePropertyList(dictionary)
        } catch {
            print(error)
        }
         */
       
        /*
            let jsonUrlString = "https://api.github.com/repos/obrienam/Vue_Dashboard/languages"
            guard let url = URL(string: jsonUrlString) else
                { return }
            
            URLSession.shared.dataTask(with: url) { (data,response,err) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    self.langs = try decoder.decode(languages.self, from: data)
                    
                    
                    DispatchQueue.main.async{
                        self.langtable=[["Vue","\(self.langs.Vue)"],["HTML","\(self.langs.HTML)"],["JavaScript","\(self.langs.JavaScript)"]]
                        
                        self.tableview.reloadData()
                    }
                    
                } catch let error {
                    print("error")
                    
                }
                
            }.resume()
        */
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true)
        
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = Bundle.main.url(forResource: String("icon"), withExtension: "png") else {
            fatalError("Could not load \(index).png")
        }

        return url as QLPreviewItem
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langtable[section].count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID2")
        if (cell==nil) {
            cell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID2")
        }
        
        cell?.textLabel?.text="\(langtable[indexPath.section][indexPath.row+1])"
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return langtable.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return langtable[section][0]
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
