//
//  PokemonProvider.swift
//  PokemonPlayground
//
//  Created by Robin on 24/07/2017.
//  Copyright © 2017 rob. All rights reserved.
//

import Moya

enum PPPokemonService {
    case pokemon(index: Int)
}

extension PPPokemonService: TargetType {
    var baseURL: URL { return URL(string: "http://pokeapi.co/api/v2")! }
    
    var path: String {
        switch self {
        case .pokemon(let index):
            return "/pokemon/\(index)/"
        }
    }
    
    var method: Method { return .get }
    
    var parameters: [String : Any]? { return nil }
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var sampleData: Data { return "{ \"weight\" : 1220, \"species\" : { \"name\" : \"mewtwo\" }, \"order\" : 203 }".utf8Encoded }
    
    var task: Task { return .request }
}

private extension String {
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
