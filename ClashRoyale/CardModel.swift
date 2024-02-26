//
//  CardModel.swift
//  ClashRoyale
//
//  Created by Horacio Mota on 25/02/24.
//

import Foundation

struct Card: Decodable {
    let name: String
    let id: Int
    let iconUrls: IconUrls

}

struct IconUrls: Decodable {
    let medium: String
    let evolutionMedium: String?
}
