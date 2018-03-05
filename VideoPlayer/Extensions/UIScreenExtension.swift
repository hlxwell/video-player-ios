//
//  UIScreenExtension.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/06.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit

extension UIScreen {
    public func navbarHeight() -> Double {
        return UIDevice.current.isX() ? Double(88.0) : Double(64.0)
    }
    
    public func statusBarHeight() -> Double {
        return Double(UIApplication.shared.statusBarFrame.size.height)
    }
}
