//
//  PPPokemonChooserTableViewCell.swift
//  PokemonPlayground
//
//  Created by Robin on 30/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit
import RAMPaperSwitch

class PPPokemonChooserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelView: UILabel?
    @IBOutlet weak var pokeBallImageView: UIImageView?
    @IBOutlet weak var cellSwitch: UISwitch?
    
    var pokemon: PPManagedPokemon? {
        didSet {
            defer {
                self.layoutSubviews()
            }
            self.labelView?.text = (pokemon?.name)!.capitalized
            
            if (pokemon?.imageData != nil && !(pokemon?.imageData.isEmpty)!) {
                self.pokeBallImageView?.image = UIImage(data: (pokemon?.imageData)!)
            } else {
                self.pokeBallImageView?.kf.indicatorType = .activity
                self.pokeBallImageView?.kf.setImage(with: URL(string: (pokemon?.imageURL)!))
            }
            
            if (pokemon?.type2.characters.count)! > 0 {
                self.pokeBallImageView?.backgroundColor = PPPokemonType(rawValue: (pokemon?.type2)!)?.color.withAlphaComponent(0.25)
            } else {
                self.pokeBallImageView?.backgroundColor = PPPokemonType(rawValue: (pokemon?.type1)!)?.color.withAlphaComponent(0.25)
            }
        }
    }
    
    // - MARK: Application lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelView?.font = Constants.kPPApplicationTitleFont
        self.cellSwitch?.isOn = false
        
        self.selectionStyle = .none
    }
}
