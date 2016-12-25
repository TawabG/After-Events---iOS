//
//  InfoViewController.swift
//  smios
//
//  Created by Fhict on 22/12/2016.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import Foundation

class InfoViewController: UIViewController {
    
    var eventName: String?
    var eventOrganisation: String?
    var eventPlace: String?
    var eventGenre: String?
    

    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var eventGenreLabel: UILabel!
    @IBOutlet weak var eventOrganisationLabel: UILabel!
    
    var event: Event?{
        didSet{
            if let eventName = event?.name {
                self.eventName = eventName
            }
            if let eventPlace = event?.place {
                self.eventPlace = eventPlace
            }
            if let eventOrganisation = event?.organisation {
                self.eventOrganisation = eventOrganisation
            }
            if let eventGenre = event?.genre {
                self.eventGenre = eventGenre
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventName = eventName {
            eventNameLabel.text = "Event: \(eventName)"
        }
        if let eventOrganisation = eventOrganisation {
            eventOrganisationLabel.text = "Organisation: \(eventOrganisation)"
        }
        if let eventGenre = eventGenre {
            eventGenreLabel.text = "Genre: \(eventGenre)"
        }
        if let eventPlace = eventPlace {
            eventPlaceLabel.text = "Place: \(eventPlace)"
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
