//
//  PPAnimatedLaunchViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 22/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit
import Spring

open class PPAnimatedLaunchViewController: UIViewController {
    // Views
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pokeBallView: SpringImageView!
    // Constraints
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    // MARK: - Application lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.backgroundColor = Constants.kPPApplicationRedColor
        bottomView.backgroundColor = Constants.kPPApplicationRedColor
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateViews()
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Animations
    
    private func animateViews() {
        pokeBallView.duration = 1.5
        pokeBallView.delay = 0.1
        pokeBallView.rotate = .pi
        pokeBallView.force = 2.5
        pokeBallView.curve = Spring.AnimationCurve.EaseInCirc.rawValue
        pokeBallView.animation = Spring.AnimationPreset.ZoomIn.rawValue
        pokeBallView.damping = 0.7
        
        pokeBallView.animateNext {
            let halfHeight = self.view.frame.size.height / 2
            self.topViewConstraint.constant -= halfHeight
            self.bottomViewConstraint.constant -= halfHeight
            
            UIView.animate(withDuration: 1.5,
                           delay: 0.5,
                           usingSpringWithDamping: 0.25,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.layoutIfNeeded()
                            self.topView.alpha = 0.0
                            self.bottomView.alpha = 0.0
            }, completion:nil)
        }
    }
}
