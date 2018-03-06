//
//  VideoListController.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/02/27.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
import Kingfisher

class VideoListViewController: UITableViewController {
    var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "VideoListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "videoListCell")
        tableView.rowHeight = 110
        tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        navigationItem.title = "Japanese Class Video"
        self.loadData()
    }

    func loadData() {
        do {
            let path = Bundle.main.url(forResource: "video_data", withExtension: "json")!
            let data = try Data(contentsOf: path)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            videos = try [Video].decode(json)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: Table view data source
extension VideoListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoListCell", for: indexPath) as! VideoListCell
        let video = videos[indexPath.row]
        let url = URL(string: video.thumbnailUrl)
        cell.author.text = video.presenterName
        cell.title.text = video.title
        cell.duration.text = video.videoDuration.convertToDisplayTime()
        cell.cover.kf.setImage(with: url) // use kingfisher to async loading image.
        cell.videoUrl = video.videoUrl

        // Add Cell appear animation
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.alpha = 1
        }, completion: nil)

        return cell
    }
}

// MARK: Table view delegate
extension VideoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        let playerViewController = PlayerViewController()
        playerViewController.videoUrl = video.videoUrl
        playerViewController.videoTitle = video.title
        playerViewController.videoDesc = video.description
        playerViewController.videoAuthor = video.presenterName
        playerViewController.videoCoverUrl = video.thumbnailUrl

        playerViewController.transitioningDelegate = self
        present(playerViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true) // deselect once user tapped.
    }
}

extension VideoListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomInTransition()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomOutTransition()
    }
}

