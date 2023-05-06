//
//  ImageData.swift
//  Pokedex
//
//  Created by Yussel Coranguez on 17/01/23.
//

import Foundation

struct ImageData: Codable {
    let sprites: Sprites
}

// MARK: - Sprites
class Sprites: Codable {
    let frontShiny: String
    let other: Other?
    
    enum CodingKeys: String, CodingKey {
        case frontShiny = "front_shiny"
        case other
    }
    
    init(other: Other?, frontShiny: String) {
        self.frontShiny = frontShiny
        self.other = other
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault, frontShiny: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - Other
struct Other: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}
