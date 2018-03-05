//
//  PlayerController.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/02/27.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

class PlayerViewController: UIViewController {
    var videoUrl: String!
    var videoTitle: String!
    var videoDesc: String!
    var videoAuthor: String!
    var videoCoverUrl: String!

    private var _player: AVPlayer!
    private var _playerLayer: AVPlayerLayer!
    private var _playerView: UIView!
    private var _playerController: PlayerController!
    private var _videoInfoView: VideoInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupPlayerViews()
        setupVideoInfo()

        // Pass player to player controller
        _playerController.player = _player
        _playerController.titleLabel.text = videoTitle
        _playerController.parentViewController = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let videoFrame = getProperPlayerFrame()
        _playerLayer.frame = videoFrame
        _playerView.frame = CGRect(x: 0, y: 0, width: videoFrame.width, height: videoFrame.height + videoFrame.maxY)
        _playerController.frame = videoFrame
        _videoInfoView.frame = getScrollViewFrame()
        _playerController.updateInterfaceForOrientation()

        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            self.navigationController?.isNavigationBarHidden = true
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    override var prefersStatusBarHidden: Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _player.pause()
    }

    // Private Methods --------------------------------------------------------

    @objc private func handlePlayerOnTap(recognizer: UITapGestureRecognizer) {
        view.addSubview(_playerController)
        _playerController.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self._playerController.alpha = 1
        }
    }

    private func setupPlayerViews() -> Void {
        // Add player view
        let playerItem = CachingPlayerItem(url: URL(string: videoUrl)!)
        _player = AVPlayer(playerItem: playerItem)
        _playerLayer = AVPlayerLayer(player: _player)
        _playerLayer.videoGravity = .resize
        _playerLayer.backgroundColor = UIColor.black.cgColor
        _playerLayer.frame = getProperPlayerFrame()
        _playerView = UIView()
        _playerView.layer.addSublayer(_playerLayer)
        view.addSubview(_playerView)

        // Add tap recognizer to show the player controller
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlayerOnTap(recognizer:)))
        _playerView.addGestureRecognizer(tapRecognizer)        
        _playerController = PlayerController.loadFromNibNamed(nibNamed: "PlayerController") as! PlayerController
        _playerController.frame = getProperPlayerFrame()
        view.addSubview(_playerController)
    }

    private func setupVideoInfo() -> Void {
        _videoInfoView = VideoInfo.loadFromNibNamed(nibNamed: "VideoInfo") as! VideoInfo
        _videoInfoView.frame = getScrollViewFrame()
        _videoInfoView.titleLabel.text = videoTitle
        _videoInfoView.authorLabel.text = videoAuthor
        _videoInfoView.descLabel.text = videoDesc
        view.addSubview(_videoInfoView)
    }

    // ScrollView height = screen height - (video height + statusbar height + navbar height)
    private func getScrollViewFrame() -> CGRect {
        let screenBounds = UIScreen.main.bounds
        var viewHeight: CGFloat = CGFloat(0)
        var y: CGFloat = CGFloat(0)
        let height = screenBounds.width / CGFloat(Constants.videoPlayerRatio)

        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            y = CGFloat(screenBounds.height) // off the screen, hide the video info.
        } else {
            y = UIApplication.shared.statusBarFrame.size.height
            y += height
            viewHeight = screenBounds.height - y
        }

        return CGRect(x: 0, y: y, width: screenBounds.width, height: viewHeight)
    }

    private func getProperPlayerFrame() -> CGRect {
        let screenBounds = UIScreen.main.bounds
        var x: CGFloat = CGFloat(0)
        var y: CGFloat = CGFloat(0)
        var width: CGFloat = screenBounds.width
        var height = screenBounds.width / CGFloat(Constants.videoPlayerRatio)

        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            if UIDevice.current.isX() {
                width = screenBounds.height * CGFloat(Constants.videoPlayerRatio)
                height = screenBounds.height
                x = CGFloat(screenBounds.width - width) / 2
            }
        } else {
            y = CGFloat(UIScreen.main.statusBarHeight())
        }

        return CGRect(x: x, y: y, width: width, height: height)
    }
}
