//
//  ApiRepositoryDetailsResult.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:


import Foundation

// MARK: - APIRepositoryDetailsResult
struct APIRepositoryDetailsResult: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let apiRepositoryDetailsResultDescription: String?
 
    let createdAt: String?
    let size, watchersCount: Int?
    let language: String?
    let forksCount: Int?
    let openIssuesCount: Int?
    let license: License?
    let defaultBranch: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case apiRepositoryDetailsResultDescription = "description"
    
        case createdAt = "created_at"
       
        case size
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case license
        case defaultBranch = "default_branch"
    }
}

// MARK: - License
struct License: Codable {
    let key, name, spdxID: String?
    let url: String?
    let nodeID: String?

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}
