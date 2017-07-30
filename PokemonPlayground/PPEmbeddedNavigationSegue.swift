//
//  PPEmbeddedNavigationSegue.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPEmbeddedNavigationSegue: UIStoryboardSegue {

    var navigationController: UINavigationController?

    public override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        
        self.navigationController = UINavigationController(rootViewController: self.destination)
        self.navigationController?.modalTransitionStyle = self.destination.modalTransitionStyle
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = Constants.kPPApplicationRedColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func perform() {
        self.source.present(self.navigationController!, animated: false, completion: nil)
    }
}
