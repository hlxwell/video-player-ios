//
//  PlayerController.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/01.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerController: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var maxMinButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    public weak var player: AVPlayer?
    private var _progressUpdateDalayTimer: Timer?

    override func awakeFromNib() {
        // Customize UI a little bit
        let progressBarIconImage = UIImage(named: "ProgressBarIcon")
        progressSlider.setThumbImage(progressBarIconImage, for: .normal)
        progressSlider.setThumbImage(progressBarIconImage, for: .highlighted)
    }

    // Change interface according to different orientation.
    public func updateInterfaceForOrientation() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            titleLabel.alpha = 1
            closeButton.isHidden = true
            maxMinButton.setImage(UIImage(named: "NormalScreenButton"), for: .normal)
        } else {
            titleLabel.alpha = 0
            closeButton.isHidden = false
            maxMinButton.setImage(UIImage(named: "FullScreenButton"), for: .normal)
        }
    }

    // MARK: IBActions

    @IBAction func close(_ sender: Any) {
        parentViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func progressChanged(_ sender: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }

        if #available(iOS 10.0, *) {
            _progressUpdateDalayTimer?.invalidate()
            _progressUpdateDalayTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] timer in
                let currentTime = Double(sender.value) * duration.seconds
                self?.player?.seek(to: CMTimeMake(Int64(currentTime * 1000), 1000))
            }
        } else {
            let currentTime = Double(sender.value) * duration.seconds
            self.player?.seek(to: CMTimeMake(Int64(currentTime * 1000), 1000))
        }
    }

    @IBAction func fullscreen(_ sender: Any) {
        let orientation: Int

        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIInterfaceOrientation.portrait.rawValue
        } else {
            orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        }
        updateInterfaceForOrientation()
        UIDevice.current.setValue(orientation, forKey: "orientation")
    }

    @IBAction func rewind(_ sender: Any) {
        let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        var newTime = currentTime - 5.0
        if newTime < 0 { newTime = 0 }
        player?.seek(to: CMTimeMake(Int64(newTime * 1000), 1000))
        updateProgressBar()
    }

    @IBAction func forward(_ sender: Any) {
        guard let duration = player?.currentItem?.duration else { return }

        let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        let newTime = currentTime + 5.0
        if newTime <= CMTimeGetSeconds(duration) {
            player?.seek(to: CMTimeMake(Int64(newTime * 1000), 1000))
        }
        updateProgressBar()
    }

    @IBAction func playAndPause(_ sender: Any) {
        if player!.isPlaying {
            player!.pause()
            playAndPauseButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        } else if player?.status == AVPlayerStatus.readyToPlay {
            player!.play()
            playAndPauseButton.setImage(UIImage(named: "PauseButton"), for: .normal)

            // Hide player controller after 1 seconds
            UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                self.alpha = 0
            }, completion: { (isCompleted) in
                self.removeFromSuperview()
            })
        }
    }

    @IBAction func handleOnTap(_ sender: Any) {
        alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (isComplete) in
            self.removeFromSuperview()
        }
    }

    // MARK: Private Methods

    // Update the progress bar according to the player current time.
    private func updateProgressBar() {
        guard let duration = player?.currentItem?.duration.seconds else { return }
        let currentTime = (player?.currentTime().seconds)!
        progressSlider.value = Float(currentTime / duration)
    }
}
