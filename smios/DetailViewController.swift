//
//  DetailViewController.swift
//  smios
//
//  Created by Fhict on 01/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    let currentDate =  NSDate()
    let endDate = NSDate()


    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
    }
    
//    @IBAction func addToCalendarBtn(_ sender: Any) {
//        
//        AddToCalender.addEventToCalendar(title: "Event title", description: "Description", startDate: currentDate, endDate: endDate)
//    
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.performSegue(withIdentifier: "showAllEvents", sender: nil)
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

