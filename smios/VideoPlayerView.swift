//
//  VideoPlayerView.swift
//  smios
//
//  Created by Fhict on 22/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override public class var layerClass:Swift.AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
}

