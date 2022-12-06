//
//  Decodable.swift
//  MarvelApp
//
//  Created by Jarvis on 06.12.2022.
//

import Foundation

struct HeroListUpruvPayload: Decodable {
    let data: HeroListPayload?
}

struct HeroListPayload: Decodable {
    let count: Int?
    let total: Int?
    let results: [HeroPayload]?
}

struct HeroPayload: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailPayload?
}

struct ThumbnailPayload: Decodable {
    let imagePath: String?
    enum CodingKeys: String, CodingKey {
        case imagePath = "path"
    }
}
