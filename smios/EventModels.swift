//
//  EventModels.swift
//  smios
//
//  Created by Fhict on 08/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation
import UIKit

class EventCategory: NSObject {
    
    // naam voor de categorie
    var name: String?
    // array voor events
    var events: [Event]?
    
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "events"{
//            for dict in value as! [[String: AnyObject]] {
//                let event = Event()
//                event.setValuesForKeys(dict)
//                events?.append(event)
//            }
//        } else {
//            super.setValue(value, forKey: key)
//        }
//    }
    
    
    static func getData(completionHandler: @escaping ([FilterEvent]) -> ())  {
        
        let urlString = "https:afty.nl/SMIOS/index2.php"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //as! [[String: Any]]
                        //as! [String:AnyObject]
                        //as! [String:Any]
                        //as! NSArray
                        //as? [[String: Any]]
                    //print(parsedData)
                    
                    // load icon hier laten zien, daarna pas kijken of t weg kan gaan, eerst gwn showen met code
                    
                    var filterEventsNew = [FilterEvent]()
                    var events = [Event]()
                    
                    //Hardstyle category
                    let hardstyleEvents = parsedData?["hardstyle"]! as? NSArray
                    for i in 0..<hardstyleEvents!.count {
                        let event = Event()
                        event.setValuesForKeys(hardstyleEvents?[i] as! Dictionary)
                        events.append(event)
                    }
                    filterEventsNew.append(FilterEvent(name: "hardstyle", events: events))
                    
                    //House category
                    var events2 = [Event]()
                    let hardstyleEvents2 = parsedData?["house"]! as? NSArray
                    for i in 0..<hardstyleEvents2!.count {
                        let event2 = Event()
                        event2.setValuesForKeys(hardstyleEvents2?[i] as! Dictionary)
                        events2.append(event2)
                    }
                    filterEventsNew.append(FilterEvent(name: "house", events: events2))
                    
                    //Raw category
                    var events3 = [Event]()
                    let hardstyleEvents3 = parsedData?["raw hardstyle"]! as? NSArray
                    for i in 0..<hardstyleEvents3!.count {
                        let event3 = Event()
                        event3.setValuesForKeys(hardstyleEvents3?[i] as! Dictionary)
                        events3.append(event3)
                    }
                    filterEventsNew.append(FilterEvent(name: "raw hardstyle", events: events3))
                    
                    //Hardcore category
                    var events4 = [Event]()
                    let hardstyleEvents4 = parsedData?["hardcore"]! as? NSArray
                    for i in 0..<hardstyleEvents4!.count {
                        let event4 = Event()
                        event4.setValuesForKeys(hardstyleEvents4?[i] as! Dictionary)
                        events4.append(event4)
                    }
                    filterEventsNew.append(FilterEvent(name: "hardcore", events: events4))
                    
                    //Techno category
                    var events5 = [Event]()
                    let hardstyleEvents5 = parsedData?["techno"]! as? NSArray
                    for i in 0..<hardstyleEvents5!.count {
                        let event5 = Event()
                        event5.setValuesForKeys(hardstyleEvents5?[i] as! Dictionary)
                        events5.append(event5)
                    }
                    filterEventsNew.append(FilterEvent(name: "techno", events: events5))

                    
                    completionHandler(filterEventsNew)
                 
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }

    
    static func sampleEventCategories() -> [EventCategory] {
        
        // Hardstyle Category
        let hardstyleCategory = EventCategory()
        hardstyleCategory.name = "Hardstyle"
        var events = [Event]()
        
        // Defqon Event
        let defqonEvent = Event()
        defqonEvent.name = "Defqon"
        defqonEvent.image = "defqonNew"
        defqonEvent.genre = "Hardstyle"
        defqonEvent.timeStart = "12:00"
        events.append(defqonEvent)
        
        let shockerzEvent = Event()
        shockerzEvent.name = "Shockerz"
        shockerzEvent.image = "shockerz"
        shockerzEvent.genre = "Hardstyle"
        shockerzEvent.timeStart = "13:00"
        events.append(shockerzEvent)
        
        let tijdmachineEvent = Event()
        tijdmachineEvent.name = "Tijdmachine"
        tijdmachineEvent.image = "tijdmachine"
        tijdmachineEvent.genre = "Hardstyle"
        tijdmachineEvent.timeStart = "22:00"
        events.append(tijdmachineEvent)
        
        
        
        hardstyleCategory.events = events
        
        // House category
        let houseCategory = EventCategory()
        houseCategory.name = "House"
        var newHouseCategory = [Event]()
        
        // House Event
        let awakenings = Event()
        awakenings.name = "Awakenings"
        awakenings.image = "awakenings"
        awakenings.genre = "House"
        awakenings.timeStart = "13:00"
        newHouseCategory.append(awakenings)
        
        houseCategory.events = newHouseCategory
        
        
        return [hardstyleCategory, houseCategory]
        
    }
}

class FilterEvent {
    var name: String?
    var events: [Event]?
    
    init(name: String, events: [Event]) {
        self.name = name
        self.events = events
    }
}

class Event: NSObject{
    
    var id: NSNumber?
    var image: String?
    var name: String?
    //var category: String?
    var genre: String?
    var info: String?
    var timeStart: String?
    var timeEnd: String?
    var url: String?
    var place: String?
    var organisation: String?
    var end: String?
    var start: String?

    
}

