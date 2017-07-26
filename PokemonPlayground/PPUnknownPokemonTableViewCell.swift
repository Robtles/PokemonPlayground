//
//  PPUnknownPokemonTableViewCell.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPUnknownPokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var labelView: UIView?
    @IBOutlet weak var pokeBallImageView: UIImageView?
    
    // - MARK: Application lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.numberLabel?.font = Constants.kPPApplicationPokedexNumberFont
        self.numberLabel?.textColor = UIColor.white
        self.labelView?.backgroundColor = UIColor.lightGray
        
        self.pokeBallImageView?.image? = (self.pokeBallImageView?.image?.withRenderingMode(.alwaysTemplate))!
        self.pokeBallImageView?.tintColor = UIColor.lightGray
    }
}
