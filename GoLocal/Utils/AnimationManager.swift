//
//  AnimationManager.swift
//  DriverRater
//
//  Created by C100-104on 04/11/20.
//  Copyright © 2020 Narola Infotech. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Animation Type
enum AnimationType {
    case present
    case dismiss
}

//MARK:- Animation Manager For Present VC Animation
 class AnimationManager: NSObject {
    let animationDuration = 0.5
    var presenting = true
    var originalFrame = CGRect.zero
}
extension AnimationManager : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        //let toView =
        //let fromView =
        let destinationView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
        let initialFrame = presenting ? originalFrame : destinationView.frame
        let finalFrame = presenting ? destinationView.frame : originalFrame

        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)


        if presenting {
            let toView = transitionContext.view(forKey: .to)!
            destinationView.transform = scaleTransform
            destinationView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            destinationView.clipsToBounds = true
            containerView.addSubview(toView)
            containerView.bringSubviewToFront(destinationView)
            toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        } else {

        }


        UIView.animate(withDuration: animationDuration, animations: {
            destinationView.transform = self.presenting ? .identity : scaleTransform
            destinationView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { (_) in
            transitionContext.completeTransition(true)
        }

    }
}
