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
import SwiftSpinner

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
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // If the Pokemon of the tapped cell is unknown, launch download
        if tableView.cellForRow(at: indexPath) is PPUnknownPokemonTableViewCell {
            var request: Cancellable? = nil
            var showError: Bool = true
            
            // Loading animation with cancellable request
            SwiftSpinner.show("\(Constants.kDownloadingDataForPokemon)\(indexPath.row + 1)...")
                        .addTapHandler({
                            SwiftSpinner.hide({
                                showError = false
                                request?.cancel()
                            })
            }, subtitle: Constants.kTapToCancel)
            
            // Download request
            request = self.pokemonProvider.request(.pokemon(index: indexPath.row + 1)) { [unowned self] (result) in
                switch result {
                case let .success(moyaResponse):
                    // Success: parse data, map into a Pokemon and reload the cell
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    var newPokemon = PPPokemon(JSON: json.dictionaryObject!)
                    newPokemon?.index = indexPath.row + 1
                    self.pokemons.append(newPokemon!)
                    SwiftSpinner.hide()
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                case .failure(_):
                    // Failure: show an error if it doesn't come from a user cancel
                    if showError {
                        SwiftSpinner.show(duration: 1.0, title: Constants.kDataLoadingError, animated: false)
                            .addTapHandler({
                                SwiftSpinner.hide()
                        })
                    }
                }
            }
        }
    }
}
