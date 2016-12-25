//
//  AllEvents.swift
//  smios
//
//  Created by Fhict on 08/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AllEventsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var eventCategories: [FilterEvent]?
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //eventCategories = EventCategory.sampleEventCategories()
        
        let progressHUD = LoadingIcon(text: "Loading Events")
        progressHUD.show()
        self.view.addSubview(progressHUD)
        
        EventCategory.getData { (eventCategories) -> () in
            self.eventCategories = eventCategories
            self.collectionView?.reloadData()
            
            //let progressHUD2 = LoadingIcon(text: "")
            progressHUD.hide()
            self.view.addSubview(progressHUD)


        }
        
        self.collectionView?.allowsSelection = true
        self.collectionView?.reloadData()
        

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    // go to eventDetailController
    func showEventDetail(event: Event){
//        let layout = UICollectionViewFlowLayout()
//        let eventDetailController = EventDetailController(collectionViewLayout: layout)
//        eventDetailController.event = event
//        navigationController?.pushViewController(eventDetailController, animated: true)
        
        
        self.performSegue(withIdentifier: "showEventDetail", sender: event)
    
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let newDetail2 = storyBoard.instantiateViewController(withIdentifier: "newEventDetail2Controller") as! UIViewController
//        //self.presentViewController(nextViewController, animated:true, completion:nil)
//        self.navigationController?.pushViewController(newDetail2, animated: true)
        

    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! CategoryCell
        //cell.eventCategory = eventCategories?[indexPath.item]
        cell.allEventsController = self
        
        cell.nameLabel.text = eventCategories?[indexPath.row].name
        cell.events = self.eventCategories?[indexPath.row].events
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let count = eventCategories?.count {
            return count
        }
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSizeMake(view.frame.width, 150)
        return CGSize(width: view.frame.width, height: 230)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetail" {
            guard let destination = segue.destination as? NewEventDetail2Controller,
            let event = sender as? Event else { return }
            destination.event = event
        }
    }
}
