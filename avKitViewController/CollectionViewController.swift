//
//  CollectionViewController.swift
//  avKitViewController
//
//  Created by Luthfi Fathur Rahman on 6/13/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let fileManager = FileManager.default
    let path = Bundle.main.resourcePath! + "/aset"
    var pathFiles = [String]()
    
    let sectionInsets = UIEdgeInsets(top: 25.0, left: 10.0, bottom: 25.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        self.pathFiles = try! self.fileManager.contentsOfDirectory(atPath: self.path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVideo" {
            let destVC = segue.destination as! AVViewController
            
            let theCell = sender as! UICollectionViewCell
            let indexPath = self.collectionView?.indexPath(for: theCell)
            destVC.selectedPath = URL(fileURLWithPath: path+"/\(pathFiles[indexPath!.item])") //URL(string: "some_url")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pathFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! PhotoCVC
        
        cell.backgroundColor = UIColor.black
        
        var isVideo = false
        var isAudio = false
        var videoImgGenerator: AVAssetImageGenerator?
        var cgImage: CGImage?
        
        let aset = AVURLAsset(url: URL(fileURLWithPath: path+"/\(pathFiles[indexPath.item])"), options: nil)
        if aset.isPlayable {
            let videoAset = aset.tracks(withMediaType: AVMediaType.video)
            let audioAset = aset.tracks(withMediaType: AVMediaType.audio)
            
            if !videoAset.isEmpty {
                isVideo = true
                isAudio = !isVideo
            } else if !audioAset.isEmpty {
                isAudio = true
                isVideo = !isAudio
            }
            
            if isVideo {
                videoImgGenerator = AVAssetImageGenerator(asset: aset)
                cgImage = try! videoImgGenerator?.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                cell.imageView.image = UIImage(cgImage: cgImage!)
            } else if isAudio {
                cell.imageView.image = UIImage(named: "Music-icon")
            }
        }
        
        cell.imageView.contentMode = .scaleAspectFit
        cell.label_fileName.text = pathFiles[indexPath.item]
        cell.sizeToFit()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem*(9/16))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
