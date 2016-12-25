//
//  NewEventDetailController.swift
//  smios
//
//  Created by Fhict on 21/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit

class NewEventDetailController: UIViewController {
    
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame:CGRect(x: 0, y: 44, width: 150, height: 150))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var event: Event?{
        didSet{
            navigationItem.title = event?.name
            if let imageName = event?.image{
                imageView.image = UIImage(named: imageName)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
       
        
        
        self.view.addSubview(imageView)
        
        let mySegmentedControl = UISegmentedControl (items: ["Info","Discussie"])
        
        let xPostion:CGFloat = 10
        let yPostion:CGFloat = 180
        let elementWidth:CGFloat = 300
        let elementHeight:CGFloat = 30
        
        mySegmentedControl.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        
//        // Make second segment selected
        mySegmentedControl.selectedSegmentIndex = 0
        
        // Add function to handle Value Changed events
        mySegmentedControl.addTarget(self, action: #selector(NewEventDetailController.segmentedValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(mySegmentedControl)
        
        
    }
    
    func segmentedValueChanged(_ sender:UISegmentedControl!){
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
