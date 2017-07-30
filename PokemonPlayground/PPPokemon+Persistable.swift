//
//  PPPersistablePokemon.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import Kingfisher

extension PPPokemon: PPPersistable {
    // Init model from Realm object
    init(managedObject: PPManagedPokemon) {
        self.index = managedObject.index
        self.imageURL = managedObject.imageURL
        self.imageData = managedObject.imageData
        self.name = managedObject.name
        self.weight = managedObject.weight
        self.height = managedObject.height
        self.type1 = PPPokemonType(rawValue: managedObject.type1)
        self.type2 = PPPokemonType(rawValue: managedObject.type2)
    }
    
    // Persist current object into Realm
    func managedObject() -> PPManagedPokemon {
        let managedPokemon = PPManagedPokemon()
        
        managedPokemon.index = self.index
        managedPokemon.imageURL = self.imageURL!
        
        if self.hasImageData {
            managedPokemon.imageData = self.imageData!
        }
        
        managedPokemon.name = self.name!
        managedPokemon.weight = self.weight!
        managedPokemon.height = self.height!

        // In some cases (like Jigglypuff #39), the Pokemon has only one type
        // but it's stored into type2 instead of type1
        guard ((self.type1?.rawValue) != nil) else {
            managedPokemon.type1 = (self.type2?.rawValue)!
            return managedPokemon
        }
        
        managedPokemon.type1 = (self.type1?.rawValue)!

        guard self.type2 != nil else {
            managedPokemon.type2 = ""
            return managedPokemon
            
        }
        managedPokemon.type2 = (self.type2?.rawValue)!
        return managedPokemon
    }
}
