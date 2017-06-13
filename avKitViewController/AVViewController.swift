//
//  ViewController.swift
//  avKitViewController
//
//  Created by Luthfi Fathur Rahman on 6/13/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVViewController: AVPlayerViewController, AVPlayerViewControllerDelegate{

    var path: URL?
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //These 3 methods give the same result to play a video. The difference is only the class that you use to create the AVPlayerView.
        
        //method 0: use this method when you're using AVPlayerViewController.
        self.player = AVPlayer(url: path!)
        self.allowsPictureInPicturePlayback = true
        
        //You may choose one of these 2 methods when create an AVPlayerView using UIViewController.
        //method 1
        /*let player = AVPlayer(url: path!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play() //auto play video when loaded
         */
        
        //method 2
        /*let player = AVPlayer(url: path!)
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play() //auto play video when loaded
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("PIP is about to start")
        UIApplication.shared.perform(#selector(URLSessionTask.suspend))
    }
    
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("PIP started")
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        print("PIP fails to start")
    }
    
    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("PIP is about to stop")
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("PIP stopped")
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return false
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void){
        let currentViewController = navigationController?.visibleViewController
        
        if currentViewController != playerViewController {
            if let topViewController = navigationController?.topViewController {
                print("restoring PIP")
                topViewController.present(playerViewController, animated: true, completion: {()
                      completionHandler(true)
                })
            } else {
                print("topViewController is nil")
            }
        } else {
            print("currentViewController is playerViewController")
        }
    }

}

