//
//  ApiRepositoriesResult.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

// MARK: - APIRepositoriesResultElement
struct APIRepositoriesResultElement: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let repoDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case repoDescription = "description"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let id: Int?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
    }
}

typealias APIRepositoriesResult = [APIRepositoriesResultElement]
