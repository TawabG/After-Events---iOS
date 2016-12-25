//
//  NewEventDetail2Controller.swift
//  smios
//
//  Created by Fhict on 21/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookCore
import FBSDKCoreKit
import FacebookLogin

class NewEventDetail2Controller: UIViewController {
    
    var eventStart: String?
    var eventEnd: String?
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var discussieView: UIView!
    
    var messages = [Message]()
    var eventName = "TestEvent"
    var facebookId = "1460032113"
    var image: String?
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var mySegmentedController: UISegmentedControl!
    
    var event: Event?{
        didSet{
            if let eventName = event?.name {
                self.navigationItem.title = eventName
                self.eventName = eventName
            }
            
            if let imageName = event?.image{
                print(imageName) // defqonNew.jpg
                image = imageName
            }
            if let eventStart = event?.start{
                self.eventStart = eventStart
                //print(eventStart)
            }
            if let eventEnd = event?.end{
                self.eventEnd = eventEnd
                print(eventEnd)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addCalendar))
        
        // Do any additional setup after loading the view.
        print(eventName)
        discussieView.isHidden = true
        eventImage.image = UIImage(named: image!)
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        //print(mySegmentedController.selectedSegmentIndex)
        switch(mySegmentedController.selectedSegmentIndex)
        {
        case 0:
            print("Doe hier code voor Info ")
            infoView.isHidden = false
            discussieView.isHidden = true
            break
        case 1:
            print("Doe hier code voor Discussie")
            infoView.isHidden = true
            discussieView.isHidden = false
            break
        default:
            break
            
        }
    }
    
    func addCalendar(){
        //print("CLicked Save")
        
        var currentDate = Date()
        print("Current Date-->\(currentDate)")
        
        //Event Start
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStart = formatter2.date(from: eventStart!)
        print("Event Start-->\(dateStart!)")
        
        //Event End
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateEnd = formatter3.date(from: eventEnd!)
        print("Event End-->\(dateEnd!)")
        
        
        let mynsdate1 = NSDate(timeIntervalSince1970: (dateStart?.timeIntervalSince1970)!)
        let mynsdate = NSDate(timeIntervalSince1970: (dateEnd?.timeIntervalSince1970)!)
        
        
       AddToCalender.addEventToCalendar(title: eventName, description: "New Event", startDate: mynsdate1, endDate: mynsdate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discussie" {
        guard let discussieController = segue.destination as? DiscussieViewController  else { return }//,
        //let event = sender as? String else { return }
        discussieController.eventName = eventName
        } else if segue.identifier == "infoview" {
            print("infoview set")
            guard let discussieController = segue.destination as? InfoViewController  else { return }//,
            discussieController.event = event
        }
    }
}
