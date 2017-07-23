//
//  PPMainViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

open class PPMainViewController: UIViewController {

    // MARK: - Application lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.kPPApplicationBlueColor
        self.title = Constants.kMainViewNavBarTitle
    }

}
