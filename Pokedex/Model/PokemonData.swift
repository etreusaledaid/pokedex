//
//  PokemonData.swift
//  Pokedex
//
//  Created by Yussel Coranguez on 17/01/23.
//

import Foundation

// MARK: - PokemonData
struct PokemonData: Codable{
    let results:[Results]?
}

// MARK: - Results
struct Results: Codable{
    let name:String?
    let url:String?
}
