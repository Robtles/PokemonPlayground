//
//  PPMyTeamViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 28/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

private enum ScreenOrientation {
    case portrait
    case landscape
}

open class PPMyTeamViewController: UIViewController {
    
    @IBOutlet var containingViews: [UIView]?
    @IBOutlet var pokemonImageViews: [UIImageView]?
    
    // MARK: - Application lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.kManageMyTeam
        self.setupImages()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            self.setupView(.landscape)
            break
        default:
            self.setupView(.portrait)
            break
        }
    }
    
    // MARK: - Setup
    private func setupView(_ orientation: ScreenOrientation) {

        if orientation == .portrait {
            return
        } else {
            return
        }
    }
    
    private final func setupImages() {
        var i = 0
        for imageView in self.pokemonImageViews! {
            if var pokemon = self.getTeamPokemonAt(index: i) {
                if pokemon.hasImageData {
                    self.pokemonImageViews?[i].image = UIImage(data: (pokemon.imageData)!)
                } else {
                    self.pokemonImageViews?[i].kf.indicatorType = .activity
                    self.pokemonImageViews?[i].kf.setImage(with: URL(string: (pokemon.imageURL)!),
                                                       completionHandler: { (image, _, _, _) in
                                                        if image != nil {
                                                            pokemon.imageData = UIImagePNGRepresentation(image!)
                                                        }
                    })
                }
                
                self.pokemonImageViews?[i].setCornerRadius(radius: (self.pokemonImageViews?[i].frame.size.width)! / 2)
                
                if let type2 = pokemon.type2 {
                    self.pokemonImageViews?[i].backgroundColor = type2.color.withAlphaComponent(0.25)
                } else {
                    self.pokemonImageViews?[i].backgroundColor = pokemon.type1?.color.withAlphaComponent(0.25)
                }
            } else {
                imageView.image = UIImage(named: "pokeball")
                imageView.image? = (imageView.image?.withRenderingMode(.alwaysTemplate))!
                imageView.tintColor = UIColor.lightGray
            }

            i += 1
        }
    }
    
    // MARK: - Helper
    private final func getTeamPokemonAt(index: Int) -> PPPokemon? {
        guard let managedPokemon = RealmHelper.shared.storedPokemons.first(where: { $0.currentStatusInTeam == index }) else {
            return nil
        }
        return PPPokemon(managedObject: managedPokemon)
    }
}
