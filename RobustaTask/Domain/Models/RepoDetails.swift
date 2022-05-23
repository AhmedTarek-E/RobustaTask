//
//  RepoDetails.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

struct RepoDetails {
    let basicInfo: RepoBasicInfo
    let owner: RepoOwner
    
    let createdAt: Date
    let size: Int
    let watchersCount: Int
    let forksCount: Int
    let language: String
    let openIssuesCount: Int
    let license: String
    let defaultBranch: String
}
