//
//  UIViewExtension.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/01.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

