//
//  StreamingViewController.swift
//  AgoraPOC
//
//  Created by Arjun  on 07/01/21.
//  Copyright © 2021 Raj. All rights reserved.
//

import UIKit
import AgoraRtcKit


class StreamingViewController: UIViewController {

    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    var channel = ""
    var userType = ""

    var agoraKit: AgoraRtcEngineKit?

     override func viewDidLoad() {
        super.viewDidLoad()
        // The following functions are used when calling Agora APIs
        initializeAgoraEngine()
        setupLocalVideo()
        joinChannel()
        
        self.setChannelProfile()
        self.setClientRole()
        
        // Adding Pan Gesture for localPlayerView
        let localViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didChangePosition))
        localView.addGestureRecognizer(localViewGestureRecognizer)
     }
    
    @objc func didChangePosition(sender: UIPanGestureRecognizer) {
         let location = sender.location(in: view)
         if sender.state == .began {
         } else if sender.state == .changed {
             if(location.x <= (UIScreen.main.bounds.width - (self.localView.bounds.width/2)) && location.x >= self.localView.bounds.width/2) {
                 self.localView.frame.origin.x = location.x
                 localView.center.x = location.x
             }
             if(location.y <= (UIScreen.main.bounds.height - (self.localView.bounds.height + 40)) && location.y >= (self.localView.bounds.height/2)+20){
                 self.localView.frame.origin.y = location.y
                 localView.center.y = location.y
             }
            
         } else if sender.state == .ended {
             print("Gesture ended")
         }
     }
    // Sets the video view layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    }
    
    func setChannelProfile(){
    agoraKit?.setChannelProfile(.liveBroadcasting)
    }
    func setClientRole(){
        if userType == "Broadcaster"{
            agoraKit?.setClientRole(.broadcaster)
        }else{
            agoraKit?.setClientRole(.audience)
        }
    }
    
    func setupLocalVideo() {
    // Enables the video module
    agoraKit?.enableVideo()
    let videoCanvas = AgoraRtcVideoCanvas()
    videoCanvas.uid = 0
    videoCanvas.renderMode = .hidden
    videoCanvas.view = localView
    // Sets the local video view
    agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel(){
            agoraKit?.joinChannel(byToken: tempToken, channelId: self.channel, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
        })
    }
    
    @IBAction func didtapLeaveChannel(_ sender: Any) {
        self.leaveChannel()
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        self.dismiss(animated: true, completion: nil)
    }
}


extension StreamingViewController: AgoraRtcEngineDelegate {
    // Monitors the firstRemoteVideoDecodedOfUid callback
    // The SDK triggers the callback when it has received and decoded the first video frame from the remote user
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
