//
//  Message.swift
//  smios
//
//  Created by Fhict on 22/12/2016.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

class Message {
    
    var fbid: String
    var event: String
    var message: String
    var facebookName: String?
    var profilePicture : UIImage?
    
    init(fbid: String, message: String, event: String) {
        self.fbid = fbid
        self.message = message
        self.event = event
        
        self.profilePicture = getProfilePicture(id: fbid, size: .small)
    }
    
    func setFacebookName(_ facebookName: String){
        self.facebookName = facebookName
    }
    
    func getProfilePicture(id: String, size: Size) -> UIImage? {
        let url = createImageURL(facebookId: id, size: size)
        return getProfilePictureFromURL(imageURL: url)
    }
    
    func createImageURL(facebookId: String, size: Size) -> String {
        return "http://graph.facebook.com/" + facebookId + "/picture?type=" + size.rawValue
    }
    
    func getProfilePictureFromURL(imageURL: String) -> UIImage? {
        let imgURLString = imageURL
        let imgURL = NSURL(string: imgURLString)
        let imageData = NSData(contentsOf: imgURL as! URL)
        let image = UIImage(data: imageData! as Data)
        
        return image
    }
    
    
}
