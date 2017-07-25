//
//  PPPokemon.swift
//  PokemonPlayground
//
//  Created by Robin on 25/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import ObjectMapper
import EZSwiftExtensions

// MARK: - Pokemon model
struct PPPokemon {
    var imageURL: String?
    var imageData: Data?
    var name: String?
    var weight: Int?
    var height: Int?
    var type1: PPPokemonType?
    var type2: PPPokemonType?
}

extension PPPokemon: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.weight <- map["weight"]
        self.height <- map["height"]
        self.imageURL <- map["sprites.front_default"]
        self.type1 <- map["types.0.type.name"]
        self.type2 <- map["types.1.type.name"]
    }
}

// MARK: - Description
extension PPPokemon: CustomStringConvertible {
    var description: String {
        var pokemonDescription: String = "Pokemon \(self.name ?? "") with height:\(self.height ?? 0) and weight:\(self.weight ?? 0) \n"
        pokemonDescription += "URL image: \(self.imageURL ?? "")\n"
        pokemonDescription += "Type 1: \((self.type1?.rawValue)!)\n"
        
        guard (self.type2 != nil) else {
            return pokemonDescription
        }
        
        pokemonDescription += "Type 2: \((self.type2?.rawValue)!)"
        return pokemonDescription
    }
}

// MARK: - Pokemon type
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

// MARK: - Pokemon type color
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
