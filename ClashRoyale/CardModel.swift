//
//  CardModel.swift
//  ClashRoyale
//
//  Created by Horacio Mota on 25/02/24.
//

import Foundation

struct Card: Decodable {
    let id: Int
    let name: String
    let maxLevel: Int
    let maxEvolutionLevel: Int?
    let elixirCost: Int?
    let iconUrls: IconUrls
    let rarity: String

}

struct IconUrls: Decodable {
    let medium: String
    let evolutionMedium: String?
}
