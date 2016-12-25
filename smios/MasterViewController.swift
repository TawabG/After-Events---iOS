//
//  MasterViewController.swift
//  smios
//
//  Created by Fhict on 01/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var arrRes = [[String:AnyObject]]()
    
    let provincies:[String] = ["Drenthe", "Flevoland", "Friesland", "Gelderland", "Groningen", "Limburg",  "Noord-Brabant", "Noord-Holland", "Overijssel", "Utrecht", "Zeeland", "Zuid-Holland"]
    
    


    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // + icon
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        let url = "https://afty.nl/SMIOS/index.php"
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //print(value) // meerdere objects
                let json = JSON(value)
                //print("JSON: \(json)") // JSON array met objects
            
            case .failure(let error):
                print(error)
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }

    // MARK: - Table View

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return provincies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = provincies[indexPath.row]
        
        return cell

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

