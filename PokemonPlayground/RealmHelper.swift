//
//  RealmHelper.swift
//  PokemonPlayground
//
//  Created by Robin on 27/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import RealmSwift

// MARK: - RealmHelper
public final class RealmHelper {
    
    let realm = try! Realm()
    
    // Singleton shared instance
    static let shared = RealmHelper()
    
    // List of Pokemon in Realm
    lazy var storedPokemons: Results<PPManagedPokemon> = { self.realm.objects(PPManagedPokemon.self) }()

    // Write function
    public func write(_ block: (WriteTransaction) throws -> Void) throws {
        let transaction = WriteTransaction()
        try realm.write {
            try block(transaction)
        }
    }
    
    func addNewPokemon(_ pokemon: PPPokemon?, updating: Bool) -> Bool {
        do {
            try RealmHelper.shared.write({ (transaction) in
                transaction.add(pokemon!, update: updating)
            })
            return true
        } catch {
            return false
        }
    }
}

public final class WriteTransaction {
    public func add<T: Persistable>(_ value: T, update: Bool) {
        RealmHelper.shared.realm.add(value.managedObject(), update: update)
    }
}

// MARK: - Persistable protocol
public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
