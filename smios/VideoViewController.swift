//
//  VideoViewController.swift
//  smios
//
//  Created by Fhict on 22/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!

    
    let captureSession = AVCaptureSession()
    var videoCaptureDevice:AVCaptureDevice?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var movieFileOutput = AVCaptureMovieFileOutput()
    
    // 1
    var outputFileLocation:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //recordButton.layer.cornerRadius = 4
        
        recordButton.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        
        let _border = CAShapeLayer()
        _border.path = UIBezierPath(roundedRect: recordButton.bounds, cornerRadius:recordButton.frame.size.width/2).cgPath
        _border.frame = recordButton.bounds
        _border.strokeColor = UIColor.white.cgColor
        _border.fillColor = UIColor.red.cgColor
        _border.lineWidth = 3.0
        recordButton.layer.addSublayer(_border)
        
        self.initializeCamera()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.setVideoOrientation()
    }
    
    // clicked on recording
    @IBAction func recordVideoButtonPressed(_ sender: Any) {
        if self.movieFileOutput.isRecording {
            self.movieFileOutput.stopRecording()
        } else {
            self.movieFileOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = self.videoOrientation()
        
            self.movieFileOutput.maxRecordedDuration = self.maxRecordedDuration()
            self.movieFileOutput.startRecording(toOutputFileURL: URL(fileURLWithPath:self.videoFileLocation()), recordingDelegate: self)
        }
                
        self.updateRecordButtonTitle()
    }
    
    @IBAction func cameraTogglePressed(_ sender: Any) {
        self.switchCameraInput()
    }
    
    // MARK: Main
    func initializeCamera(){
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let discovery = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) as AVCaptureDeviceDiscoverySession
        
        for device in discovery.devices as [AVCaptureDevice] {
            
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.back {
                    self.videoCaptureDevice = device
                }
            }
            
        }
        
        if videoCaptureDevice != nil {
            do {
                try self.captureSession.addInput(AVCaptureDeviceInput(device: self.videoCaptureDevice))
                
                if let audioInput = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) {
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput))
                }
                
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                
                self.previewView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                self.previewView.layer.addSublayer(self.previewLayer!)
                self.previewLayer?.frame = self.previewView.frame
                
                self.setVideoOrientation()
                
                self.captureSession.addOutput(self.movieFileOutput)
                
                self.captureSession.startRunning()
                
            } catch {
                print(error)
            }
        }
        
    }
    
    func setVideoOrientation() {
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
                self.previewLayer?.frame = self.view.bounds
            }
        }
    }
    
    func switchCameraInput() {
        self.captureSession.beginConfiguration()
        
        var existingConnection:AVCaptureDeviceInput!
        
        for connection in self.captureSession.inputs {
            let input = connection as! AVCaptureDeviceInput
            if input.device.hasMediaType(AVMediaTypeVideo) {
                existingConnection = input
            }
            
        }
        
        self.captureSession.removeInput(existingConnection)
        
        var newCamera:AVCaptureDevice!
        if let oldCamera = existingConnection {
            if oldCamera.device.position == .back {
                newCamera = self.cameraWithPosition(position: .front)
            } else {
                newCamera = self.cameraWithPosition(position: .back)
            }
        }
        
        var newInput:AVCaptureDeviceInput!
        
        do {
            newInput = try AVCaptureDeviceInput(device: newCamera)
            self.captureSession.addInput(newInput)
        } catch {
            print(error)
        }
        
        self.captureSession.commitConfiguration()
    }
    
    // MARK: AVCaptureFileOutputDelegate
    // klaar met opnemen
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        //
        print("Finished recording: \(outputFileURL)")
        
        // 2
        self.outputFileLocation = outputFileURL
        self.performSegue(withIdentifier: "videoPreview", sender: nil)
        
    }
    
    // MARK: Helpers
    
    func videoOrientation() -> AVCaptureVideoOrientation {
        
        var videoOrientation:AVCaptureVideoOrientation!
        
        let orientation:UIDeviceOrientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            videoOrientation = .portrait
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        default:
            videoOrientation = .portrait
        }
        
        return videoOrientation
        
    }
    
    func videoFileLocation() -> String {
        return NSTemporaryDirectory().appending("videoFile.mov")
    }
    
    func updateRecordButtonTitle() {
        if !self.movieFileOutput.isRecording {
            recordButton.setTitle("Recording..", for: .normal)
        } else {
            recordButton.setTitle("Record", for: .normal)
        }
    }
    
    func maxRecordedDuration() -> CMTime {
        let seconds : Int64 = 10
        let preferredTimeScale : Int32 = 1
        return CMTimeMake(seconds, preferredTimeScale)
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice?
    {
        let discovery = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) as AVCaptureDeviceDiscoverySession
        for device in discovery.devices as [AVCaptureDevice] {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let preview = segue.destination as! VideoPreviewViewController
        preview.fileLocation = self.outputFileLocation
    }
    
}

