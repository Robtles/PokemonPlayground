//
//  PPPokemonTeamTableView.swift
//  PokemonPlayground
//
//  Created by Robin on 30/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPPokemonTeamChooserViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView?
    @IBOutlet weak var alertView: UIView?
    @IBOutlet weak var chooseAPokemonLabel: UILabel?
    @IBOutlet weak var availablePokemonsTableView: UITableView?
    @IBOutlet weak var alertCenterYConstraint: NSLayoutConstraint?
    @IBOutlet weak var alertHeight: NSLayoutConstraint?
    
    let chosablePokemons = PPRealmHelper.shared.storedPokemons
        .filter({ $0.currentStatusInTeam == -1 })
        .sorted(by: { $0.index < $1.index })

    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chooseAPokemonLabel?.font = Constants.kPPApplicationButtonFont
        self.chooseAPokemonLabel?.text = Constants.kChooseAPokemon
        
        self.availablePokemonsTableView?.dataSource = self
        self.availablePokemonsTableView?.delegate = self
        
        self.transitioningDelegate = self
    }
    
    static func presentIn(_ viewController: UIViewController) {
        let pokemonChooserViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pokemonTeamChooserViewController")
        pokemonChooserViewController.modalPresentationStyle = .overCurrentContext
        
        if Thread.isMainThread {
            viewController.present(pokemonChooserViewController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                viewController.present(pokemonChooserViewController, animated: true, completion: nil)
            }
        }
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

// MARK: - Table view data source
extension PPPokemonTeamChooserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chosablePokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonChooserCell") as! PPPokemonChooserTableViewCell
        cell.pokemon = self.chosablePokemons[indexPath.row]
        return cell
    }
}

// MARK: - Table view delegate
extension PPPokemonTeamChooserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension PPPokemonTeamChooserViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPPresentTeamChooserViewAnimationController()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PPDismissTeamChooserViewAnimationController()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
private final class PPPresentTeamChooserViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: PPPokemonTeamChooserViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PPPokemonTeamChooserViewController
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

private final class PPDismissTeamChooserViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: PPPokemonTeamChooserViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! PPPokemonTeamChooserViewController
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.overlayView?.alpha = 0.0
        })
        
        var finishFrame = fromViewController.alertView?.frame
        finishFrame?.origin.y = fromViewController.view.frame.size.height + 15
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            fromViewController.alertView?.frame = finishFrame!
        }, completion: { result in
            transitionContext.completeTransition(true)
        })
    }
}
