//
//  ZoomInTransition.swift
//  VideoPlayer
//
//  Created by Michael He on 2018/03/05.
//  Copyright © 2018 Michael He. All rights reserved.
//

import UIKit
class ZoomInTransition: NSObject {}

extension ZoomInTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.insertSubview(to.view, belowSubview: from.view)

        to.view.alpha = 0
        to.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: UIViewAnimationOptions.init(rawValue: 0),
            animations: {
                from.view.alpha = 0
                from.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

                to.view.alpha = 1
                to.view.transform = CGAffineTransform.identity
            },
            completion: { (finished: Bool) in
                from.view.alpha = 1
                from.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
