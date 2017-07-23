//
//  PPConstants.swift
//  PokemonPlayground
//
//  Created by Robin on 22/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import EZSwiftExtensions

struct Constants {
    /// Main View title - Navbar
    static let kMainViewNavBarTitle = "Pokémon Playground"
    
    /// Playground String
    static let kPlaygroundString = "Playground"
    
    /// My Team String
    static let kMyTeam = "Mon équipe"
    
    /// Fetch Pokémons String
    static let kPokedex = "Pokédex"
    
    /// ShowMainViewController Segue
    static let kShowMainViewControllerSegue = "showMainViewController"
    
    /// Application main red color
    static let kPPApplicationRedColor = UIColor(hexString: "#DF1A1A")
    
    /// Application main blue color
    static let kPPApplicationBlueColor = UIColor(hexString: "#C7FFFE")
    
    /// Application yellow button
    static let kPPApplicationYellowButtonColor = UIColor(hexString: "#FFC22C")
    
    /// Application blue button
    static let kPPApplicationBlueButtonColor = UIColor(hexString: "#0061BA")
    
    /// Application button font
    static let kPPApplicationButtonFont = UIFont.boldSystemFont(ofSize: 18.0)
}

extension Constants {
    static func ketchumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ketchum", size: fontSize)!
    }
    
    static func italicKetchumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ketchum-Italic", size: fontSize)!
    }
}
