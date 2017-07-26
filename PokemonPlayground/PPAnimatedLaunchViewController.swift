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
        
        self.topView.backgroundColor = Constants.kPPApplicationRedColor
        self.bottomView.backgroundColor = Constants.kPPApplicationRedColor
        self.view.backgroundColor = Constants.kPPApplicationBlueColor
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateViews()
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func showMainViewController() {
        self.performSegue(withIdentifier: Constants.kShowMainViewControllerSegue, sender: nil)
    }
    
    // MARK: - Animations
    private func animateViews() {
        self.pokeBallView.duration = 1.5
        self.pokeBallView.delay = 0.1
        self.pokeBallView.rotate = .pi
        self.pokeBallView.force = 2.5
        self.pokeBallView.curve = Spring.AnimationCurve.EaseInCirc.rawValue
        self.pokeBallView.animation = Spring.AnimationPreset.ZoomIn.rawValue
        self.pokeBallView.damping = 0.7
        
        self.pokeBallView.animateNext {
            let halfHeight = self.view.frame.size.height / 2
            self.topViewConstraint.constant -= halfHeight
            self.bottomViewConstraint.constant -= halfHeight
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.5,
                           usingSpringWithDamping: 0.25,
                           initialSpringVelocity: 0.8,
                           options: [],
                           animations: {
                            self.view.layoutIfNeeded()
                            self.topView.alpha = 0.0
                            self.bottomView.alpha = 0.0
                            self.pokeBallView.alpha = 0.0
            }, completion:{ result in
                self.showMainViewController()
            })
        }
    }
}
