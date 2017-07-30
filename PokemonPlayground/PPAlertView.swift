//
//  PPAlertView.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var overlayView: UIView?
    @IBOutlet weak var alertView: UIView?
    @IBOutlet weak var alertCenterYConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var pokemonIndexLabel: UILabel?
    @IBOutlet weak var pokemonImageView: UIImageView?
    @IBOutlet weak var pokemonNameLabel: UILabel?
    @IBOutlet weak var pokemonHeightWeightLabel: UILabel?
    @IBOutlet weak var firstTypeLabel: PPPokemonTypeLabel?
    @IBOutlet weak var secondTypeLabel: PPPokemonTypeLabel?
    @IBOutlet weak var firstTypeConstraint: NSLayoutConstraint?
    @IBOutlet weak var secondTypeConstraint: NSLayoutConstraint?
    
    var pokemon: PPPokemon?
    
    var isDismissingByBottom: Bool = false
    
    // MARK: - Initializers
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PPAlertView", bundle: nil)
        self.transitioningDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pokemon = self.pokemon else {
            self.dismiss(animated: true, completion:nil)
            return
        }
        
        self.pokemonIndexLabel?.text = "\(pokemon.index)"
        self.pokemonIndexLabel?.textColor = UIColor.white
        self.pokemonIndexLabel?.font = Constants.ketchumFont(ofSize: 15.0)
        self.pokemonIndexLabel?.backgroundColor = Constants.kPPApplicationRedColor
        self.pokemonIndexLabel?.setCornerRadius(radius: (self.pokemonIndexLabel?.frame.size.width)! / 2)
        self.pokemonNameLabel?.text = pokemon.name?.capitalized
        self.pokemonNameLabel?.font = Constants.kPPApplicationTitleBoldFont
        self.pokemonHeightWeightLabel?.text = "\((pokemon.weight?.toKg)!) | \((pokemon.height?.toM)!)"
        self.pokemonHeightWeightLabel?.font = Constants.kPPApplicationStandardFont
        self.pokemonHeightWeightLabel?.textColor = UIColor.darkGray
        
        if (self.pokemon?.hasImageData)! {
            self.pokemonImageView?.image = UIImage(data: (pokemon.imageData)!)
        } else {
            let index = (self.pokemon?.index)!
            self.pokemonImageView?.kf.indicatorType = .activity
            self.pokemonImageView?.kf.setImage(with: URL(string: (pokemon.imageURL)!),
                                               completionHandler: { (image, _, _, _) in
                                                if image != nil {
                                                    PPRealmHelper.shared.setDataForPokemon(withIndex: index,
                                                                                         data: UIImagePNGRepresentation(image!)!)
                                                }
            })
        }
        
        self.firstTypeLabel?.type = (pokemon.type1)!
        guard let type2 = pokemon.type2 else {
            self.secondTypeLabel?.isHidden = true
            self.pokemonImageView?.backgroundColor = pokemon.type1?.color.withAlphaComponent(0.25)
            return
        }
        self.pokemonImageView?.backgroundColor = type2.color.withAlphaComponent(0.25)
        self.secondTypeLabel?.isHidden = false
        self.secondTypeLabel?.type = type2
        self.firstTypeConstraint?.constant += 40
        self.secondTypeConstraint?.constant -= 40
    }

    static func presentIn(_ viewController: UIViewController, withPokemon pokemon: PPPokemon) {
        let alertViewController = PPAlertViewController()
        alertViewController.pokemon = pokemon
        alertViewController.modalPresentationStyle = .overCurrentContext
        
        if Thread.isMainThread {
             viewController.present(alertViewController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                viewController.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPDismissAlertViewAnimationController()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPPresentAlertViewAnimationController()
    }
    
    // MARK: - IBActions
    @IBAction func alertMoving(_ sender: Any) {
        let gesture = sender as! UIPanGestureRecognizer
        
        switch gesture.state {
        case .ended:
            let velocity = gesture.velocity(in: self.alertView).y
            if fabs(velocity) / 10 < 30 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertCenterYConstraint?.constant = 0.0
                    self.view.layoutIfNeeded()
                })
            } else {
                self.isDismissingByBottom = velocity > 0
                
                self.dismiss(animated: true, completion:nil)
            }
        case .began, .changed:
            let translation = gesture.translation(in: self.alertView)
            self.alertCenterYConstraint?.constant = translation.y
            self.view.layoutIfNeeded()
        default:
            break
        }
    }
    
    @IBAction func tapToDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
private final class PPPresentAlertViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: PPAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PPAlertViewController
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

private final class PPDismissAlertViewAnimationController: NSObject,  UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: PPAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! PPAlertViewController
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
