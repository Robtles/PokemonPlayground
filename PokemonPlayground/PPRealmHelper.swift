//
//  PPRealmHelper.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import RealmSwift

// MARK: - PPRealmHelper
public final class PPRealmHelper {
    
    let realm = try! Realm()
    
    // Singleton shared instance
    static let shared = PPRealmHelper()
    
    // List of Pokemon in Realm
    lazy var storedPokemons: Results<PPManagedPokemon> = { self.realm.objects(PPManagedPokemon.self) }()

    // Write function
    public func write(_ block: (PPWriteTransaction) throws -> Void) throws {
        let transaction = PPWriteTransaction()
        try realm.write {
            try block(transaction)
        }
    }
}

public final class PPWriteTransaction {
    public func add<T: PPPersistable>(_ value: T, update: Bool) {
        PPRealmHelper.shared.realm.add(value.managedObject(), update: update)
    }
}

// MARK: - PPPersistable protocol
public protocol PPPersistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

// MARK: - Realm operation on Pokemons
extension PPRealmHelper {
    func addNewPokemon(_ pokemon: PPPokemon?, updating: Bool) -> Bool {
        do {
            try PPRealmHelper.shared.write({ (transaction) in
                transaction.add(pokemon!, update: updating)
            })
            return true
        } catch {
            return false
        }
    }
    
    func removeTeamPokemon(withIndex index: Int, completion: @escaping () -> Void) {
        guard let managedPokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.currentStatusInTeam == index }) else {
            completion()
            return
        }
        
        try! PPRealmHelper.shared.realm.write {
            managedPokemon.currentStatusInTeam = -1
        }
        completion()
    }
    
    func addPokemonInTeam(pokemonIndex: Int, teamIndex: Int, completion: @escaping () -> Void) {
        guard let managedPokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.index == pokemonIndex }) else {
            completion()
            return
        }
        
        try! PPRealmHelper.shared.realm.write {
            managedPokemon.currentStatusInTeam = teamIndex
        }
        completion()
    }
    
    func setDataForPokemon(withIndex index: Int, data: Data) {
        guard let managedPokemon = PPRealmHelper.shared.storedPokemons.first(where: { $0.index == index }) else {
            return
        }
        
        try! PPRealmHelper.shared.realm.write {
            managedPokemon.imageData = data
        }
    }
}
