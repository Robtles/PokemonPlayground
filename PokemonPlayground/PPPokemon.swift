//
//  PPPokemon.swift
//  PokemonPlayground
//
//  Created by Robin on 25/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import ObjectMapper

// MARK: - Pokemon model
struct PPPokemon {
    var index: Int = 0
    var imageURL: String?
    var imageData: Data?
    var name: String?
    var weight: Int?
    var height: Int?
    var type1: PPPokemonType?
    var type2: PPPokemonType?
    
    var hasImageData: Bool {
        return self.imageData != nil && !(self.imageData?.isEmpty)!
    }
}

// MARK: - Mappable Pokemon object
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
        var pokemonDescription: String = "Pokemon #\(self.index) \(self.name ?? "") with height:\(self.height ?? 0) and weight:\(self.weight ?? 0) \n"
        pokemonDescription += "URL image: \(self.imageURL ?? "")\n"
        pokemonDescription += "Type 1: \((self.type1?.rawValue)!)\n"
        
        guard (self.type2 != nil) else {
            return pokemonDescription
        }
        
        pokemonDescription += "Type 2: \((self.type2?.rawValue)!)"
        return pokemonDescription
    }
}
