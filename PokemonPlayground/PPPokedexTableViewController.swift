//
//  PPPokedexTableViewController.swift
//  PokemonPlayground
//
//  Created by Robin on 23/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class PPPokedexTableViewController: UITableViewController {

    var pokemons: [PPPokemon] = []
    var pokemonProvider = MoyaProvider<PPPokemonService>()
    
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
        guard let pokemon = pokemons.first(where: { $0.index == indexPath.row + 1 }) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "unknownPokemonCell") as! PPUnknownPokemonTableViewCell
            cell.numberLabel?.text = "#\(indexPath.row + 1) "
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexPokemonCell") as! PPPokedexTableViewCell
        cell.pokemon = pokemon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if tableView.cellForRow(at: indexPath) is PPUnknownPokemonTableViewCell {
            self.pokemonProvider.request(.pokemon(index: indexPath.row + 1)) { [unowned self] (result) in
                switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    var newPokemon = PPPokemon(JSON: json.dictionaryObject!)
                    newPokemon?.index = indexPath.row + 1
                    self.pokemons.append(newPokemon!)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                case let .failure(moyaError):
                    print("Error on request: \(moyaError)")
                }
            }
        }
    }
}
