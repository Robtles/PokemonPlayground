//
//  PPOverlayedModalViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 30/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPOverlayedModalViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView?
    @IBOutlet weak var alertView: UIView?
    var isDismissingByBottom: Bool = false
}

// MARK: - UIViewControllerTransitioningDelegate
extension PPOverlayedModalViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPPresentOverlayedModalViewAnimationController()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPDismissOverlayedModalViewAnimationController()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
private final class PPPresentOverlayedModalViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: PPOverlayedModalViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PPOverlayedModalViewController
        let duration = self.transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        toViewController.view.frame = containerView.frame
        containerView.addSubview(toViewController.view)
        
        toViewController.overlayView?.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
            toViewController.overlayView?.alpha = 0.6
        })
        
        let finishFrame = toViewController.alertView?.frame
        var startingFrame = finishFrame
        startingFrame?.origin.y = -((finishFrame?.height)!)
        toViewController.alertView?.frame = startingFrame!
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            toViewController.alertView?.frame = finishFrame!
        }, completion: { result in
            transitionContext.completeTransition(result)
        })
    }
}

private final class PPDismissOverlayedModalViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: PPOverlayedModalViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! PPOverlayedModalViewController
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.overlayView?.alpha = 0.0
        })
        
        var finishFrame = fromViewController.alertView?.frame
        finishFrame?.origin.y = fromViewController.isDismissingByBottom ? fromViewController.view.frame.size.height : -(finishFrame?.height)!
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            fromViewController.alertView?.frame = finishFrame!
        }, completion: { result in
            transitionContext.completeTransition(true)
        })
    }
}
