//
//  RepoDetailsMapper.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

extension APIRepositoryDetailsResult {
    func map() -> RepoDetails {
        let formatter = ISO8601DateFormatter()
        
        return RepoDetails(
            basicInfo: RepoBasicInfo(
                id: id ?? 0,
                name: name ?? "",
                description: apiRepositoryDetailsResultDescription ?? ""
            ),
            owner: RepoOwner(
                id: owner?.id ?? 0,
                name: owner?.login ?? "",
                avatar: owner?.avatarURL ?? ""
            ),
            createdAt: formatter.date(from: createdAt ?? "") ?? Date.now,
            size: size ?? 0,
            watchersCount: watchersCount ?? 0,
            forksCount: forksCount ?? 0,
            language: language ?? "",
            openIssuesCount: openIssuesCount ?? 0,
            license: license?.name ?? "",
            defaultBranch: defaultBranch ?? ""
        )
    }
}
