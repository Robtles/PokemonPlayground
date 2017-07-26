//
//  PPPokemonTypeLabel.swift
//  PokemonPlayground
//
//  Created by Robin on 26/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPPokemonTypeLabel: UILabel {
    
    var type: PPPokemonType? {
        didSet {
            self.textColor = type!.foregroundColor
            self.text = self.type?.rawValue.uppercased()
            self.backgroundColor = type!.color
            let borderColor = type!.color.darker(by: 15.0)
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = Constants.kPPApplicationStandardFont
        self.setCornerRadius(radius: 6.0)
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clear
    }
}
