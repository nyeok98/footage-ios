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
    
    var playerVC = AVPlayerViewController()
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let videoPath = Bundle.main.path(forResource: "Intro", ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: videoPath)
            print(videoURL)
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            player.volume = 0
            player.actionAtItemEnd = .none
            playerLayer.frame = view.layer.bounds
            view.backgroundColor = .clear
            view.layer.insertSublayer(playerLayer, at: 0)
        }
    }
}
