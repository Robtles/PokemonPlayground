//
//  PPPokemonType.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

enum PPPokemonType: String {
    case normal = "normal"
    case fighting = "fighting"
    case flying = "flying"
    case poison = "poison"
    case ground = "ground"
    case rock = "rock"
    case bug = "bug"
    case ghost = "ghost"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
}

extension PPPokemonType {
    var color: UIColor {
        switch self {
        case .normal:
            return UIColor.white
        case .fighting:
            return UIColor(hexString: "#F4B26F")!
        case .flying:
            return UIColor(hexString: "#C6E2FF")!
        case .poison:
            return UIColor(hexString: "#AB529E")!
        case .ground:
            return UIColor(hexString: "#BA936C")!
        case .rock:
            return UIColor(hexString: "#90755A")!
        case .bug:
            return UIColor(hexString: "#A1D0A6")!
        case .ghost:
            return UIColor(hexString: "#6D4167")!
        case .fire:
            return UIColor(hexString: "#F29243")!
        case .water:
            return UIColor(hexString: "#43E5F2")!
        case .grass:
            return UIColor(hexString: "#44EA56")!
        case .electric:
            return UIColor(hexString: "#FFE67C")!
        case .psychic:
            return UIColor(hexString: "#F292E4")!
        case .ice:
            return UIColor(hexString: "#9CF8FF")!
        case .dragon:
            return UIColor(hexString: "#C4E5E7")!
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .normal, .ice:
            return UIColor.black
        default:
            return UIColor.white
        }
    }
}
