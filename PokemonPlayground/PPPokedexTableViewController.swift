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
        guard let managedPokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.index == indexPath.row + 1 }) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "unknownPokemonCell") as! PPUnknownPokemonTableViewCell
            cell.numberLabel?.text = "#\(indexPath.row + 1) "
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexPokemonCell") as! PPPokedexTableViewCell
        cell.pokemon = PPPokemon(managedObject: managedPokemon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // If the Pokemon of the tapped cell is unknown, launch download
        if tableView.cellForRow(at: indexPath) is PPUnknownPokemonTableViewCell {
            
            self.loadNewPokemon(withIndex: (indexPath.row + 1))
        } else if tableView.cellForRow(at: indexPath) is PPPokedexTableViewCell {
            
            guard let pokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.index == indexPath.row + 1 }) else {
                return
            }
            PPAlertViewController.presentIn(self, withPokemon: PPPokemon(managedObject: pokemon))
        }
    }
    
    // MARK: - Helpers
    private func loadNewPokemon(withIndex index: Int) {
        
        var request: Cancellable? = nil
        var showError: Bool = true
        
        // Loading animation with cancellable request
        SwiftSpinner.show("\(Constants.kDownloadingDataForPokemon)\(index)...")
            .addTapHandler({
                SwiftSpinner.hide({
                    showError = false
                    request?.cancel()
                })
            }, subtitle: Constants.kTapToCancel)
        
        // Download request
        request = self.pokemonProvider.request(.pokemon(index: index)) { [unowned self] (result) in
            switch result {
            case let .success(moyaResponse):
                // Success: parse data, map into a Pokemon and reload the cell
                let data = moyaResponse.data
                let json = JSON(data: data)
                var newPokemon = PPPokemon(JSON: json.dictionaryObject!)
                newPokemon?.index = index
                
                guard newPokemon != nil && PPRealmHelper.shared.addNewPokemon(newPokemon, updating: false) else {
                    // If no Pokemon or could not add to Realm: fallthrough to failure case
                    fallthrough
                }
                
                SwiftSpinner.hide()
                self.tableView.reloadRows(at: [IndexPath(row: index - 1, section: 0)], with: .none)
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
