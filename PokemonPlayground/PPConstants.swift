//
//  PPConstants.swift
//  PokemonPlayground
//
//  Created by Robin on 22/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import EZSwiftExtensions

struct Constants {
    
    /*******************
     *
     * STRINGS
     *
     *******************/
    
    /// Main View title - Navbar
    static let kMainViewNavBarTitle = "Pokémon Playground"
    
    /// Playground String
    static let kPlaygroundString = "Playground"
    
    /// My Team String
    static let kMyTeam = "My Team"
    
    /// Manage my Team String
    static let kManageMyTeam = "Manage my Team"
    
    /// Fetch Pokémons String
    static let kPokedex = "Pokédex"
    
    /// Downloading data for Pokemon String
    static let kDownloadingDataForPokemon = "Downloading data for Pokemon #"
    
    /// Data Loading Error String
    static let kDataLoadingError = "Could not load data"
    
    /// Tap to Cancel String
    static let kTapToCancel = "Tap to Cancel"
    
    /// ShowMainViewController Segue
    static let kShowMainViewControllerSegue = "showMainViewController"
    
    
    /*******************
     *
     * COLORS
     *
     *******************/
    
    /// Application main red color
    static let kPPApplicationRedColor = UIColor(hexString: "#DF1A1A")
    
    /// Application main blue color
    static let kPPApplicationBlueColor = UIColor(hexString: "#C7FFFE")
    
    /// Application yellow button
    static let kPPApplicationYellowButtonColor = UIColor(hexString: "#FFC22C")
    
    /// Application blue button
    static let kPPApplicationBlueButtonColor = UIColor(hexString: "#0061BA")
    
    /*******************
     *
     * FONTS
     *
     *******************/
    
    /// Application button font
    static let kPPApplicationButtonFont = UIFont.boldSystemFont(ofSize: 18.0)
    
    /// Application title bold font
    static let kPPApplicationTitleBoldFont = UIFont.boldSystemFont(ofSize: 16.0)
    
    /// Application standard font
    static let kPPApplicationStandardFont = UIFont.systemFont(ofSize: 14.0)
    
    /// Application lighter font
    static let kPPApplicationLighterFont = UIFont.systemFont(ofSize: 13.0)
    
    /// Application button font
    static let kPPApplicationPokedexNumberFont = Constants.ketchumFont(ofSize: 16.0)
    
    /*******************
     *
     * OTHERS
     *
     *******************/
    
    /// Current amount of Pokémon handled
    static let kPPAmountOfPokemon = 151
}

extension Constants {
    static func ketchumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ketchum", size: fontSize)!
    }
    
    static func italicKetchumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ketchum-Italic", size: fontSize)!
    }
}
