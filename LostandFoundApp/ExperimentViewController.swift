//
//  ExperimentViewController.swift
//  LostandFoundApp
//
//  Created by Aidan O'Brien on 3/29/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit

struct languages: Codable {
    let Vue: Int
    let HTML: Int
    let JavaScript: Int
}

class ExperimentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableview: UITableView!
    var langs:languages!
    var langtable=[[String(),String()]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
        
        // Do any additional setup after loading the view.
    }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
