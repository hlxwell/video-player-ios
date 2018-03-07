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

    private weak var _player: AVPlayer?

    var player: AVPlayer {
        get {
            return _player!
        }
        set {
            _player = newValue
            addTimeObserver()
        }
    }

    override func awakeFromNib() {
        // Customize UI a little bit
        let progressBarIconImage = UIImage(named: "ProgressBarIcon")
        progressSlider.setThumbImage(progressBarIconImage, for: .normal)
        progressSlider.setThumbImage(progressBarIconImage, for: .highlighted)
    }

    @IBAction func close(_ sender: Any) {
        parentViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func progressChanged(_ sender: UISlider) {
        guard let duration = _player?.currentItem?.duration else { return }

        let currentTime = Double(sender.value) * duration.seconds
        _player?.seek(to: CMTimeMake(Int64(currentTime * 1000), 1000))
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
        let currentTime = CMTimeGetSeconds((_player?.currentTime())!)
        var newTime = currentTime - 5.0
        if newTime < 0 { newTime = 0 }
        _player?.seek(to: CMTimeMake(Int64(newTime * 1000), 1000))
        updateProgressBar()
    }

    @IBAction func forward(_ sender: Any) {
        guard let duration = _player?.currentItem?.duration else { return }

        let currentTime = CMTimeGetSeconds((_player?.currentTime())!)
        let newTime = currentTime + 5.0
        if newTime <= CMTimeGetSeconds(duration) {
            _player?.seek(to: CMTimeMake(Int64(newTime * 1000), 1000))
        }
        updateProgressBar()
    }

    @IBAction func playAndPause(_ sender: Any) {
        if _player!.isPlaying {
            _player!.pause()
            playAndPauseButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        } else {
            _player!.play()
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

    // Private Methods -----------------------------------------------------

    // Update the progress bar according to the player current time.
    private func updateProgressBar() {
        guard let duration = _player?.currentItem?.duration.seconds else { return }
        let currentTime = (_player?.currentTime().seconds)!
        progressSlider.value = Float(currentTime / duration)
    }

    // Add Time observer to the player, so we can show the time on the player.
    private func addTimeObserver() {
        let updateInterval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _player?.addPeriodicTimeObserver(
            forInterval: updateInterval,
            queue: DispatchQueue.main,
            using: { [weak self] time in
                guard let currentItem = self?._player?.currentItem else { return }

                let currentTime = Int((self?._player?.currentTime().seconds)! * 1000).convertToDisplayTime()
                var duration: String = "00:00" // Default Value
                if currentItem.duration.seconds > 0 {
                    duration = Int(currentItem.duration.seconds * 1000).convertToDisplayTime()
                }
                self?.durationLabel.text = String(format: "%@ / %@", currentTime, duration)
            }
        )
    }
}
