//
//  EventModelNew.swift
//  smios
//
//  Created by Fhict on 10/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation

class NewEvents {
    var id: String?
    var image: String?
    var name: String?
    var category: String?
    var timeStart: String?
    var timeEnd: String?
    var url: String?
    var place: String?
    var organisation: String?
    
    init(id: String, image: String, name:String, category:String, timeStart:String, timeEnd:String, url:String, place:String, organisation:String){
        self.id = id
        self.image = image
        self.name = name
        self.category = category
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.url =  url
        self.place = place
        self.organisation = organisation
    }
    
//    init(eventDictionary: [String:Any]){
//        // letterlijk de string van het json object
//        id = eventDictionary["id"] as? NSNumber
//        self.name = eventDictionary["name"] as? String
//        category = eventDictionary["genre"] as? String
//        image = eventDictionary["image"] as? String
//        url = URL(string: eventDictionary["url"] as! String)
//        timeStart = eventDictionary["start"] as? String
//        timeEnd = eventDictionary["end"] as? String
//        place = eventDictionary["place"] as? String
//        organisation = eventDictionary["organisation"] as? String
//    }
    
    
}
