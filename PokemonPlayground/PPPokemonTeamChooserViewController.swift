//
//  PPPokemonTeamTableView.swift
//  PokemonPlayground
//
//  Created by Robin on 30/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPPokemonTeamChooserViewController: PPOverlayedModalViewController {
    
    @IBOutlet weak var chooseAPokemonLabel: UILabel?
    @IBOutlet weak var availablePokemonsTableView: UITableView?
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var pokeballImageView: UIImageView?
    @IBOutlet weak var emptyLabel: UILabel?
    
    @IBOutlet weak var alertCenterYConstraint: NSLayoutConstraint?
    @IBOutlet weak var alertHeight: NSLayoutConstraint?
    
    var delegate: PPPokemonTeamChooserDelegate?
    
    var teamIndex: Int?
    
    let chosablePokemons = PPRealmHelper.shared.storedPokemons
        .filter({ $0.currentStatusInTeam == -1 })
        .sorted(by: { $0.index < $1.index })

    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chooseAPokemonLabel?.font = Constants.kPPApplicationButtonFont
        self.chooseAPokemonLabel?.text = Constants.kChooseAPokemon
        self.transitioningDelegate = self
        
        guard chosablePokemons.count > 0 else {
            self.availablePokemonsTableView?.isHidden = true
            
            self.emptyView?.isHidden = false
            self.emptyLabel?.text = Constants.kEmptyLabel
            self.emptyLabel?.font = Constants.kPPApplicationStandardFont
            self.emptyLabel?.textColor = UIColor.lightGray
            
            self.pokeballImageView?.image? = (self.pokeballImageView?.image?.withRenderingMode(.alwaysTemplate))!
            self.pokeballImageView?.tintColor = UIColor.lightGray
            
            return
        }
        
        self.emptyView?.isHidden = true
        self.availablePokemonsTableView?.isHidden = false
        self.availablePokemonsTableView?.dataSource = self
        self.availablePokemonsTableView?.delegate = self
    }
    
    static func presentIn(_ viewController: UIViewController, index: Int, delegate: PPPokemonTeamChooserDelegate) {
        let pokemonChooserViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "pokemonTeamChooserViewController") as! PPPokemonTeamChooserViewController
        pokemonChooserViewController.modalPresentationStyle = .overCurrentContext
        pokemonChooserViewController.teamIndex = index
        pokemonChooserViewController.delegate = delegate
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = self.chosablePokemons[indexPath.row]

        self.delegate?.didChoosePokemon(withIndex: pokemon.index, teamIndex: teamIndex!)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion:nil)
        }
    }
}

// MARK: - PokemonChooserDelegate
protocol PPPokemonTeamChooserDelegate {
    func didChoosePokemon(withIndex index: Int, teamIndex: Int)
}
