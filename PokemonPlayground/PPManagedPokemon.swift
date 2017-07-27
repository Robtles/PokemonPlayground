//
//  PPManagedPokemon.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import RealmSwift

class PPManagedPokemon: Object {
    dynamic var index: Int = 0
    dynamic var imageURL: String = ""
    dynamic var imageData: Data = Data()
    dynamic var name: String = ""
    dynamic var weight: Int = -1
    dynamic var height: Int = -1
    dynamic var type1: String = ""
    dynamic var type2: String = ""
    dynamic var currentStatusInTeam = -1
    
    override class func primaryKey() -> String? {
        return "index"
    }
}
