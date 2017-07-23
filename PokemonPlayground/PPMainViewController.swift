//
//  PPMainViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

open class PPMainViewController: UIViewController {

    @IBOutlet weak var pokeBallImageView: UIImageView?
    @IBOutlet weak var playgroundLabel: UILabel?
    @IBOutlet weak var myTeamButton: UIButton?
    @IBOutlet weak var pokedexButton: UIButton?
    
    // MARK: - Application lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.kPPApplicationBlueColor
        self.title = Constants.kMainViewNavBarTitle
        
        self.pokeBallImageView?.image? = (self.pokeBallImageView?.image?.withRenderingMode(.alwaysTemplate))!
        self.pokeBallImageView?.tintColor = Constants.kPPApplicationRedColor
        
        self.playgroundLabel?.text = Constants.kPlaygroundString
        self.playgroundLabel?.font = Constants.ketchumFont(ofSize: 40.0)
        self.playgroundLabel?.textColor = UIColor.black
        
        self.myTeamButton?.setTitle(Constants.kMyTeam, for: .normal)
        self.myTeamButton?.titleLabel?.font = Constants.kPPApplicationButtonFont
        self.myTeamButton?.backgroundColor = Constants.kPPApplicationYellowButtonColor
        
        self.pokedexButton?.setTitle(Constants.kPokedex, for: .normal)
        self.pokedexButton?.titleLabel?.font = Constants.kPPApplicationButtonFont
        self.pokedexButton?.backgroundColor = Constants.kPPApplicationBlueButtonColor
    }

}
