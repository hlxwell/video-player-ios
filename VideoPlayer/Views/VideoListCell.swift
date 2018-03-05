//
//  VideoListCell.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/02/27.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var videoUrl: String!

    override func awakeFromNib() {
        cover.layer.cornerRadius = 5
    }
}
