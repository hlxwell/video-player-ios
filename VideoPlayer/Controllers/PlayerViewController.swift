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
import Reachability

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
    private var _loadingIndicator: UIActivityIndicatorView!

    override var prefersStatusBarHidden: Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupPlayerViews()
        setupVideoInfo()
        addLoadingIndicator()

        // Pass player to player controller
        _playerController.player = _player
        _playerController.titleLabel.text = videoTitle

        handleConnectivity()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let videoFrame = getPlayerFrame()
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

    private func setupPlayerViews() {
        // Add player view
        let playerItem = CachingPlayerItem(url: URL(string: videoUrl)!)
        playerItem.delegate = self
        _player = AVPlayer(playerItem: playerItem)
        _playerLayer = AVPlayerLayer(player: _player)
        _playerLayer.videoGravity = .resize
        _playerLayer.backgroundColor = UIColor.black.cgColor
        _playerLayer.frame = getPlayerFrame()
        _playerView = UIView()
        _playerView.layer.addSublayer(_playerLayer)
        view.addSubview(_playerView)

        // Add tap recognizer to show the player controller
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlayerOnTap(recognizer:)))
        _playerView.addGestureRecognizer(tapRecognizer)
        _playerController = PlayerController.loadFromNibNamed(nibNamed: "PlayerController") as! PlayerController
        _playerController.frame = getPlayerFrame()
    }

    private func setupVideoInfo() {
        _videoInfoView = VideoInfo.loadFromNibNamed(nibNamed: "VideoInfo") as! VideoInfo
        _videoInfoView.frame = getScrollViewFrame()
        _videoInfoView.titleLabel.text = videoTitle
        _videoInfoView.authorLabel.text = videoAuthor
        _videoInfoView.descLabel.text = videoDesc
        view.addSubview(_videoInfoView)
    }

    // Portrait Mode:
    // `y = video height + statusbar height`
    // `height = screen height - y`
    //
    // Landscape Mode:
    // We need to hide it, so `y = screen height` that's enough
    //
    private func getScrollViewFrame() -> CGRect {
        let screenBounds = UIScreen.main.bounds
        var y: CGFloat = CGFloat(0)
        var height: CGFloat = CGFloat(0)
        let videoHeight = screenBounds.width / CGFloat(Constants.videoPlayerRatio)

        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            y = CGFloat(screenBounds.height)
        } else {
            y = CGFloat(UIScreen.main.statusBarHeight())
            y += videoHeight
            height = screenBounds.height - y
        }
        return CGRect(x: 0, y: y, width: screenBounds.width, height: height)
    }

    // Portrait Mode:
    // `y = statusbar height`
    // `height = screen width / video size ratio`
    //
    // Landscape Mode:
    // We only need to process for the iPhoneX, since iPhoneX is too wide:
    // `((screen width - video width) / 2, 0, screen height * video size ratio, screen height)`
    //
    // other iPhone Screen:
    // `(0, 0, screen width, screen width / video size ratio)`
    //
    private func getPlayerFrame() -> CGRect {
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

    // Private Methods ------------------------------------------

    private func addLoadingIndicator() {
        _loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        _loadingIndicator.hidesWhenStopped = true
        let loadingIndicatorCenter: CGPoint = CGPoint(
            x: (getPlayerFrame().size.width / 2),
            y: (getPlayerFrame().origin.y + getPlayerFrame().size.height / 2)
        )
        _loadingIndicator.center = loadingIndicatorCenter
        _loadingIndicator.startAnimating()
        view.addSubview(_loadingIndicator)
    }
}

extension PlayerViewController: CachingPlayerItemDelegate {
    // Hide progress bar when the player is ready
    func playerItemReadyToPlay(_ playerItem: CachingPlayerItem) {
        _loadingIndicator.stopAnimating()
        view.addSubview(_playerController)
    }

    // Show progress bar when the player is stalled
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        _loadingIndicator.startAnimating()
        _playerController.removeFromSuperview()
    }
}

extension PlayerViewController {
    func handleConnectivity() {
        let reachability = Reachability()!
        reachability.whenUnreachable = { _ in
            let alert = UIAlertController(
                title: "No network",
                message: "You don't have network connection, so the app might not work for you.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
