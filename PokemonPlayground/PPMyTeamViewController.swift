//
//  PPMyTeamViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 28/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit
import SCLAlertView

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
class PPMyTeamViewController: UIViewController {
    
    var containingViews: [UIView] = []
    var pokemonImageViews: [UIImageView] = []
    var pokemonLabels: [UILabel] = []
    
    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.kManageMyTeam
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Resetting the view
        self.containingViews = []
        self.pokemonImageViews = []
        self.pokemonLabels = []
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
    fileprivate final func setupView(_ orientation: ScreenOrientation,
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
        containingView.tag = index
        
        containingView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                   action: #selector(self.showPokemonChooserView(_:))))
        
        let imageWidth = containingView.frame.size.height * 0.6
        let labelWidth = containingView.frame.size.height * 0.8
        
        let imageView = UIImageView(x: (containingView.frame.size.width - imageWidth) / 2,
                                    y: (containingView.frame.size.height - imageWidth) / 2,
                                    w: imageWidth,
                                    h: imageWidth)
        
        let label = UILabel(x: (containingView.frame.size.width - labelWidth) / 2,
                            y: (containingView.frame.size.height - imageWidth) / 2 + (labelWidth - 45),
                            w: labelWidth,
                            h: 30)
        label.isHidden = true
        
        self.pokemonImageViews.append(imageView)
        self.pokemonLabels.append(label)
        self.containingViews.append(containingView)
        
        self.setImageForView(index)
        
        containingView.addSubview(imageView)
        containingView.addSubview(label)
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
            
            let label = self.pokemonLabels[i]
            
            label.backgroundColor = Constants.kPPApplicationRedColor
            label.textColor = UIColor.white
            label.font = Constants.ketchumFont(ofSize: 18.0)
            label.textAlignment = .center
            label.setCornerRadius(radius: 6.0)
            label.text = pokemon.name?.capitalized
            label.isHidden = false
            
        } else {
            self.pokemonImageViews[i].backgroundColor = UIColor.clear
            self.pokemonImageViews[i].image = UIImage(named: "pokeball")
            self.pokemonImageViews[i].image? = (self.pokemonImageViews[i].image?.withRenderingMode(.alwaysTemplate))!
            self.pokemonImageViews[i].tintColor = UIColor.lightGray
        }
    }
    
    // MARK: - Helper
    private final func getTeamPokemonAt(index: Int) -> PPPokemon? {
        guard let managedPokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.currentStatusInTeam == index }) else {
            return nil
        }
        return PPPokemon(managedObject: managedPokemon)
    }
    
    @objc private final func showPokemonChooserView(_ sender : UITapGestureRecognizer) {
        
        let index = (sender.view?.tag)!
        
        guard let pokemonAtIndex = self.getTeamPokemonAt(index: index) else {
            PPPokemonTeamChooserViewController.presentIn(self, index: index, delegate: self)
            return
        }
        
        let alertView = SCLAlertView()
        
        alertView.addButton("Remove") {
            
            PPRealmHelper.shared.removeTeamPokemon(withIndex: index) {
                
                alertView.hideView()
                self.pokemonLabels[index].isHidden = true
                
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
        }
        
        alertView.addButton("Replace") {
            
            PPRealmHelper.shared.removeTeamPokemon(withIndex: index) {
                
                alertView.hideView()
                self.pokemonLabels[index].isHidden = true
                
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
                
                PPPokemonTeamChooserViewController.presentIn(self, index: index, delegate: self)
            }
        }
        
        
        alertView.showWarning("Warning",
            subTitle: "What do you want to do with \(pokemonAtIndex.name!.capitalized)?",
            closeButtonTitle: "Nothing bye")
    }
}

// MARK: - PPPokemonTeamChooserDelegate
extension PPMyTeamViewController: PPPokemonTeamChooserDelegate {
    
    func didChoosePokemon(withIndex index: Int, teamIndex: Int) {
        
        PPRealmHelper.shared.addPokemonInTeam(pokemonIndex: index, teamIndex: teamIndex) {
            
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
    }
}
