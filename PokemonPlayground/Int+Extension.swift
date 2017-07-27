//
//  Int+Extension.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

extension Int {
    var toKg: String {
        return "\(String(format: "%.1f", Float(self) / 10)) kg".replacingOccurrences(of: ".", with: ",")
    }
    
    var toM: String {
        return "\(String(format: "%.1f", Float(self) / 10)) m".replacingOccurrences(of: ".", with: ",")
    }
}
