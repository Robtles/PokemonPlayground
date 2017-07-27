//
//  PPPokedexTableViewCell.swift
//  PokemonPlayground
//
//  Created by Robin on 26/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit
import Kingfisher

class PPPokedexTableViewCell: UITableViewCell {
   
    @IBOutlet weak var labelView: UIView?
    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var pokemonImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var weightLabel: UILabel?
    @IBOutlet weak var heightLabel: UILabel?
    @IBOutlet weak var firstTypeLabel: PPPokemonTypeLabel?
    @IBOutlet weak var secondTypeLabel: PPPokemonTypeLabel?
    
    var pokemon: PPPokemon? {
        didSet {
            self.numberLabel?.text = "#\((pokemon?.index)!) "
            self.nameLabel?.text = (pokemon?.name)!.capitalized
            self.weightLabel?.text = (pokemon?.weight?.toKg)!
            self.heightLabel?.text = (pokemon?.height?.toM)!
            
            if (pokemon?.hasImageData)! {
                self.pokemonImageView?.image = UIImage(data: (pokemon?.imageData)!)
            } else {
                self.pokemonImageView?.kf.setImage(with: URL(string: (pokemon?.imageURL)!),
                                                   completionHandler: { [unowned self] (image, _, _, _) in
                                                    if image != nil {
                                                        self.pokemon?.imageData = UIImagePNGRepresentation(image!)
                                                    }
                })
            }

            self.pokemonImageView?.setCornerRadius(radius: (self.pokemonImageView?.frame.size.width)! / 2)
            
            self.firstTypeLabel?.type = (pokemon?.type1)!
            guard let type2 = pokemon?.type2 else {
                self.secondTypeLabel?.isHidden = true
                self.pokemonImageView?.backgroundColor = pokemon?.type1?.color.withAlphaComponent(0.25)
                return
            }
            self.pokemonImageView?.backgroundColor = type2.color.withAlphaComponent(0.25)
            self.secondTypeLabel?.isHidden = false
            self.secondTypeLabel?.type = type2
        }
    }
    
    // - MARK: Application lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.numberLabel?.font = Constants.kPPApplicationPokedexNumberFont
        self.numberLabel?.textColor = UIColor.white
        self.labelView?.backgroundColor = Constants.kPPApplicationRedColor
        
        self.nameLabel?.font = Constants.kPPApplicationTitleBoldFont
        
        self.weightLabel?.font = Constants.kPPApplicationLighterFont
        self.weightLabel?.textColor = UIColor.darkGray
        self.heightLabel?.font = Constants.kPPApplicationLighterFont
        self.heightLabel?.textColor = UIColor.darkGray
        
    }
}
