//
//  PlayerController.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/01.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
import AVFoundation

// TODO Add loading status: if player?.status == AVPlayerStatus.readyToPlay

class PlayerController: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var maxMinButton: UIButton!

    public weak var player: AVPlayer?

    override func awakeFromNib() {
    }

    @IBAction func progressChanged(_ sender: Any) {
    }

    @IBAction func fullscreen(_ sender: Any) {
        let orientation: Int
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIInterfaceOrientation.portrait.rawValue
        } else {
            orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        }
        
        UIDevice.current.setValue(orientation, forKey: "orientation")
    }

    @IBAction func rewind(_ sender: Any) {
    }

    @IBAction func forward(_ sender: Any) {
    }

    @IBAction func playAndPause(_ sender: Any) {
        if player!.isPlaying {
            player!.pause()
            playAndPauseButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        } else {
            player!.play()
            playAndPauseButton.setImage(UIImage(named: "PauseButton"), for: .normal)
        }
    }
}
