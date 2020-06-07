//
//  Poke.swift
//  Pods-Ursus Demo
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation

struct PokeRequest<JSON: Encodable>: Encodable {
    
    var action: String = "poke"
    var id: Int
    var ship: String
    var app: String
    var mark: String
    var json: JSON
    
    enum CodingKeys: String, CodingKey {
        case action
        case id
        case ship
        case app
        case mark
        case json
    }
    
}
