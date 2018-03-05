//
//  Video.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/02/27.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
import protocol Decodable.Decodable
import Decodable

struct Video: Codable {
    let title: String
    let presenterName: String
    let description: String
    let thumbnailUrl: String
    let videoUrl: String
    let videoDuration: Int
}

extension Video: Decodable {
    public static func decode(_ json: Any) throws -> Video {
        return try Video(
            title: json => "title",
            presenterName: json => "presenter_name",
            description: json => "description",
            thumbnailUrl: json => "thumbnail_url",
            videoUrl: json => "video_url",
            videoDuration: json => "video_duration"
        )
    }
}
