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
    
    var x: CGFloat {
        switch self {
        case .portrait: return 2
        case .landscape: return 3
        }
    }
    
    var y: CGFloat {
        switch self {
        case .portrait: return 3
        case .landscape: return 2
        }
    }
}

/*
 * TODO: This class can be highly improved.
 * I need to have two different layouts for portrait and landscape modes.
 * Portrait mode: 3 rows of 2 Pokemons, landscape mode: 2 rows of 3 Pokemons.
 * I tried to do so with AutoLayout, or even using tools like SnapKit, but couldn't get it working...
 * So I ended up setting the frames directly (but dynamically though). 
 * Any idea to improve this code would be greatly appreciated.
 */
open class PPMyTeamViewController: UIViewController {
    
    var containingViews: [UIView] = []
    var pokemonImageViews: [UIImageView] = []
    
    // MARK: - Application lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.kManageMyTeam
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            let size = CGSize(width: self.view.size.width,
                              height: self.view.size.height - self.navigationBarHeight)
            self.setupView(.landscape, withSize: size)
            break
        default:
            let size = CGSize(width: self.view.size.width,
                              height: self.view.size.height - UIApplication.shared.statusBarFrame.height - self.navigationBarHeight)
            self.setupView(.portrait, withSize: size)
            break
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Resetting the view
        self.containingViews = []
        self.pokemonImageViews = []
        self.view.removeSubviews()
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            let sizeToUse = CGSize(width: size.width,
                                   height: size.height + UIApplication.shared.statusBarFrame.height)
            self.setupView(.landscape, withSize: sizeToUse)
            break
        default:
            let sizeToUse = CGSize(width: size.width,
                                   height: size.height - self.navigationBarHeight)
            self.setupView(.portrait, withSize: sizeToUse)
            break
        }
    }
    
    // MARK: - Setup
    private final func setupView(_ orientation: ScreenOrientation,
                           withSize size: CGSize) {
        for i in 0..<6 {
            self.setupConstraints(forView: i,
                                  orientation: orientation,
                                  andSize: size)
        }
    }
    
    private final func setupConstraints(forView index: Int, orientation: ScreenOrientation, andSize size: CGSize) {
        let containingView = UIView(x: size.width / orientation.x * CGFloat(index % Int(orientation.x)),
                                    y: size.height / orientation.y * CGFloat(index % Int(orientation.y)),
                                    w: size.width / orientation.x,
                                    h: size.height / orientation.y)
        
        let imageWidth = containingView.frame.size.height * 0.6
        
        let imageView = UIImageView(x: (containingView.frame.size.width - imageWidth) / 2,
                                    y: (containingView.frame.size.height - imageWidth) / 2,
                                    w: imageWidth,
                                    h: imageWidth)
        
        self.pokemonImageViews.append(imageView)
        self.containingViews.append(containingView)
        
        self.setImageForView(index)
        
        containingView.addSubview(imageView)
        self.view.addSubview(containingView)
    }
    
    private final func setImageForView(_ i: Int) {
        if let pokemon = self.getTeamPokemonAt(index: i) {
            if pokemon.hasImageData {
                self.pokemonImageViews[i].image = UIImage(data: (pokemon.imageData)!)
            } else {
                self.pokemonImageViews[i].kf.indicatorType = .activity
                self.pokemonImageViews[i].kf.setImage(with: URL(string: (pokemon.imageURL)!))
            }
            
            self.pokemonImageViews[i].setCornerRadius(radius: self.pokemonImageViews[i].frame.size.width / 2)
            
            if let type2 = pokemon.type2 {
                self.pokemonImageViews[i].backgroundColor = type2.color.withAlphaComponent(0.25)
            } else {
                self.pokemonImageViews[i].backgroundColor = pokemon.type1?.color.withAlphaComponent(0.25)
            }
        } else {
            self.pokemonImageViews[i].image = UIImage(named: "pokeball")
            self.pokemonImageViews[i].image? = (self.pokemonImageViews[i].image?.withRenderingMode(.alwaysTemplate))!
            self.pokemonImageViews[i].tintColor = UIColor.lightGray
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
