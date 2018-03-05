//
//  AVPlayerExtension.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/05.
//  Copyright © 2018 Michael He. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return (self.rate != 0 && self.error == nil)
    }
}
