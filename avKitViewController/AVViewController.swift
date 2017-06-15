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

    var selectedPath: URL?
    let fileManager = FileManager.default
    let path = Bundle.main.resourcePath! + "/aset"
    var pathFiles = [String]()
    var paths: [URL]?
    let playerViewController = AVPlayerViewController()
    let playerQueue = AVQueuePlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.pathFiles = try! self.fileManager.contentsOfDirectory(atPath: self.path)
        
        for pathFile in pathFiles {
            self.paths?.append(URL(fileURLWithPath: path+"/\(pathFile)"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //These 3 methods give the same result to play a video. The difference is only the class that you use to create the AVPlayerView.
        
        //method 0: use this method when you're using AVPlayerViewController.
        self.player = AVPlayer(url: selectedPath!)
        
        self.allowsPictureInPicturePlayback = true
        
        if !(player?.currentItem?.asset.isPlayable)! {
            let alertStatus = UIAlertController (title: "Media Playback Error", message: "This media can not be played. Please select another media.", preferredStyle: UIAlertControllerStyle.alert)
            alertStatus.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler:  {(action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertStatus, animated: true, completion: nil)
        }
        
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
    
    func skipToPreviousItem(for: AVPlayerViewController) {
        let curr_item = ((self.player?.currentItem?.asset) as? AVURLAsset)?.url
        let curr_index = paths?.index(of: curr_item!)
        var willBePlayed: URL?
        if curr_index!-1 < 0 {
            willBePlayed = paths?[(paths?.endIndex)!]
        } else {
            willBePlayed = paths?[curr_index!-1]
        }
        self.player = AVPlayer(url: willBePlayed!)
    }
    
    func skipToNextItem(for: AVPlayerViewController){
        let curr_item = ((self.player?.currentItem?.asset) as? AVURLAsset)?.url
        let curr_index = paths?.index(of: curr_item!)
        var willBePlayed: URL?
        if curr_index!+1 > (paths?.count)! {
            willBePlayed = paths?[(paths?.startIndex)!]
        } else {
            willBePlayed = paths?[curr_index!+1]
        }
        self.player = AVPlayer(url: willBePlayed!)
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

