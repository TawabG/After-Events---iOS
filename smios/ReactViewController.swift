//
//  ReactViewController.swift
//  smios
//
//  Created by Fhict on 16/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import React

class ReactViewController: UIViewController {

    let ip = "145.93.49.0:8081"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSLog("Hello")
        let jsCodeLocation = URL(string: "http://\(ip)/index.ios.bundle?platform=ios")
        
        let mockData:NSDictionary = ["scores":
            [
                ["Event":"Defqon", "Place":"Biddinghuizen"],
                ["Event":"Shockerz", "Place":"Den Bosch"]
            ]
        ]
        
        let rootView = RCTRootView(
            bundleURL: jsCodeLocation,
            moduleName: "reactTest",
            initialProperties: mockData as [NSObject : AnyObject],
            launchOptions: nil
        )
        let vc = UIViewController()
        vc.view = rootView
        self.present(vc, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
