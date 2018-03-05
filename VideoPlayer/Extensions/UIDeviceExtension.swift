//
//  UIDeviceExtension.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/06.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit

extension UIDevice {
    public func isX() -> Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}
