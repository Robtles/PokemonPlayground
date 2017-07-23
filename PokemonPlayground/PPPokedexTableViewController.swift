//
//  PPPokedexTableViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit

class PPPokedexTableViewController: UITableViewController {

    // MARK: - Application lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.kPokedex
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.kPPAmountOfPokemon
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unknownPokemonCell") as! PPUnknownPokemonTableViewCell
        cell.number = indexPath.row + 1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
