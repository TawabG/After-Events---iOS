//
//  VideoPreviewViewController.swift
//  smios
//
//  Created by Fhict on 22/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//


import UIKit
import AVKit
import AVFoundation

class VideoPreviewViewController: UIViewController {
    
    // 1
    static let assetKeysRequiredToPlay = ["playable","hasProtectedContent"]
    // 2
    let player = AVPlayer()
    
    // 3
    var asset:AVURLAsset? {
        // 9
        didSet {
            guard let newAsset = asset else { return }
            loadURLAsset(newAsset)
        }
    }
    
    // 4
    var playerLayer:AVPlayerLayer? {
        return playerView.playerLayer
    }
    
    // 5
    var playerItem:AVPlayerItem? {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
            player.actionAtItemEnd = .none
        }
    }
    
    // 6
    var fileLocation:URL? {
        // 10
        didSet {
            self.asset = AVURLAsset(url: self.fileLocation!)
        }
    }
    
    

    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    //@IBOutlet weak var playerView:PlayerView!
    //@IBOutlet weak var saveButton:UIButton!
   // @IBOutlet weak var playPauseButton:UIButton!
    //@IBOutlet weak var playerView: VideoPlayerView!
    //@IBOutlet weak var playPauseButton: UIButton!
    //@IBOutlet weak var saveButton: UIButton!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 11
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        addObserver(self, forKeyPath: "player.rate", options: [.new, .initial], context: nil)
        
        // 14
        NotificationCenter.default.addObserver(self, selector: #selector(playerReachedEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        // 7
        self.playerView.playerLayer.player = player
    }
    
    // 13
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: "player.currentItem.status", context: nil)
        removeObserver(self, forKeyPath: "player.rate", context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Main
    
    // 8
    func loadURLAsset(_ asset: AVURLAsset) {
        
        asset.loadValuesAsynchronously(forKeys: VideoPreviewViewController.assetKeysRequiredToPlay) {
            DispatchQueue.main.async {
                guard asset == self.asset else { return }
                for key in VideoPreviewViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if !asset.isPlayable || asset.hasProtectedContent {
                        let message = "Video is not playable."
                        self.showAlert(title: "Error", message: message, dismiss: false)
                        return
                    }
                    
                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
                        
                        let message = "Failed to load"
                        self.showAlert(title: "Error", message: message, dismiss: false)
                        
                        
                        return
                    }
                }
                
                self.playerItem = AVPlayerItem(asset: asset)
            }
        }
    }
    
    
    

    
    @IBAction func closePreview(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveToLibrary(_ sender: Any) {
        self.saveVideoToUserLibrary()
    }

    @IBAction func playPauseButtonPressed(_ sender: Any) {
        self.updatePlayPauseButtonTitle()

    }
    
    
    // MARK: Callbacks
    
    // 12
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "player.currentItem.status" {
            //Do something
            playPauseButton.isHidden = false
            saveButton.isHidden = false
            
        }
    }
    
    // 15
    func playerReachedEnd(notification:NSNotification) {
        //To restart video
        self.asset = AVURLAsset(url: self.fileLocation!)
        self.updatePlayPauseButtonTitle()
    }
    
    
    // MARK: Helpers
    func saveVideoToUserLibrary(){
        PhotoManager().saveVideoToUserLibrary(fileUrl: self.fileLocation!) { (success, error) in
            if success {
                self.showAlert(title: "Success", message: "Video saved.", dismiss: true)
            } else {
                self.showAlert(title: "Error", message: (error?.localizedDescription)!, dismiss: false)
            }
        }
    }
    
    func showAlert(title:String, message:String, dismiss:Bool) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if dismiss {
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // 16
    func updatePlayPauseButtonTitle() {
        if player.rate > 0 {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
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
