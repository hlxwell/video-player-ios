//
//  TimeHelper.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/02/28.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit

extension Int {
    func convertToDisplayTime() -> String {
        let hours = self / 1000 / 3600
        let minutes = self / 1000 % 3600 / 60
        let seconds = self / 1000 % 60
        
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}
