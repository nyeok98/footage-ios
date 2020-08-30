//
//  FL_VideoVC.swift
//  footage
//
//  Created by Wootae on 8/29/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FL_VideoVC: UIViewController {
    
    var player: AVPlayer?
    
    @IBOutlet weak var backBoard: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playBackgroundVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundVideo()
        nextButton.alpha = 0
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            UIView.animate(withDuration: 3) {
                self.nextButton.alpha = 1
            }
        }
    }
    
    func playBackgroundVideo() {
        let path = Bundle.main.path(forResource: "Intro", ofType: "mp4")
        let url = NSURL(fileURLWithPath: path!)
        player = AVPlayer(url: url as URL)
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.pause
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        backBoard.layer.addSublayer(playerLayer)
        backBoard.layer.insertSublayer(playerLayer, below: nextButton.layer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player?.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.positiveInfinity)
    }

}
