//
//  DiscussieViewController.swift
//  smios
//
//  Created by Fhict on 22/12/2016.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation
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

class DiscussieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginButtonDelegate {
    
    var messages = [Message]()
    //var eventName = "TestEvent"
    var facebookId = "1460032113"
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reactionField: UITextField!
    
    @IBAction func postButton_Click(_ sender: Any) {
        if let message = reactionField.text {
            if message.isEmpty {
                showAlert(title: "Error", message: "No message", button: "OK")
            } else {
                self.postMessage(message)
            }
        }
    }
    
    var eventName: String?{
        didSet{
            
            if let eventName = eventName {
                print(eventName)
                self.navigationItem.title = eventName
                self.eventName = eventName
                
                getMessages(festival: eventName)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(event?.name)
        // Do any additional setup after loading the view.
        //print(eventName)
        
         tableView.delegate = self
         tableView.dataSource = self
         
         refreshControl = UIRefreshControl()
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(DiscussieViewController.refresh(_:)), for: UIControlEvents.valueChanged)
         tableView.addSubview(refreshControl)
         
         NotificationCenter.default.addObserver(self, selector: #selector(DiscussieViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(DiscussieViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
         
         checkLoggedIn()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TABLEVIEW DELEGATES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        if let name = message.facebookName {
            cell.name.text = name
        }
        
        if let image = message.profilePicture {
            cell.profilePicture.image = image
        }
        
        cell.reaction.text = messages[indexPath.row].message
        
        return cell
    }
    
    // FACEBOOK LOGIN DELEGATE
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out")
        checkLoggedIn()
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Logged in")
        checkLoggedIn()
    }
    
    // IMPLEMENTED CODE
    func checkLoggedIn(){
        if AccessToken.current != nil {
            getMyFacebookProfile()
            showPostMessage(true)
        } else {
            showPostMessage(false)
        }
    }
    
    func getMyFacebookProfile(){
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: nil)
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if let error = error {
                print("Error: \(error)")
            } else if let result = result {
                let json = JSON(result)
                print(json)
                
                self.facebookId = json["id"].rawValue as! String
                print(self.facebookId)
            }
        })
    }
    
    func showPostMessage(_ show: Bool){
        if(show){
            reactionField.isHidden = false
            postButton.isHidden = false
        } else {
            reactionField.isHidden = true
            postButton.isHidden = true
        }
        initLoginButton()
    }
    
    func initLoginButton(){
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        //view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 300))
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 0))
    }
    
    func postMessage(_ message: String){
        let url = "https://afty.nl/SMIOS/postMessage.php"
        
        let parameters: [String: String] = [
            "fbid" : facebookId,
            "eventName" : eventName!,
            "message" : message
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                print("Post complete")
                if let data = response.result.value{
                    print("DATA: \(data)")
                    self.getMessages(festival: self.eventName!)
                }
                break
            case .failure(_):
                if let error = response.result.error{
                    print(error)
                    self.showAlert(title: "Failed", message: "Message not posted", button: "OK")
                }
                break
            }
        }
    }
    
    func getMessages(festival : String){
        messages = [Message]()
        
        let urlString = "https://afty.nl/SMIOS/getMessages.php"
        
        let parameters: [String: String] = [
            "eventName" : festival
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    
                    for i in 0..<json.count {
                        let fbid = json[i]["fbid"].rawValue as! String
                        let reaction = json[i]["message"].rawValue as! String
                        let event = json[i]["name"].rawValue as! String
                        
                        let message = Message(fbid: fbid, message: reaction, event: event)
                        
                        self.getFacebookUsername(id: fbid) { facebookName in
                            if let facebookName = facebookName{
                                print(facebookName)
                                
                                message.setFacebookName(facebookName)
                                
                                self.messages.append(message)
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            } else{
                                print("elseeee")
                            }
                        }
                    }
                }
                break
            case .failure(_):
                if let error = response.result.error{
                    print("Error for Messages:" + festival)
                    print(error)
                }
                break
            }
        }
    }
    
    func getFacebookUsername(id: String, completionhandler: ((String?) -> Void)?) {
        let url = "https://graph.facebook.com/\(id)?key=value&access_token=1803492599913936%7C827da89292c929bd8738083647cbecaa"
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let facebookName = json["name"].rawValue as! String
                completionhandler?(facebookName)
            case .failure(let error):
                print(error)
                print("Error occured")
                completionhandler?(nil)
            }
        }
    }
    
    func showAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // HANDLE KEYBOARDLAYOUT
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // REFRESHCONTROLS
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        getMessages(festival: self.eventName!)
    }
    
}
