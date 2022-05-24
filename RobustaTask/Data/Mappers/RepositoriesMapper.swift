//
//  RepositoriesMapper.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

extension APIRepositoriesResultElement {
    func map() -> MiniRepo {
        return MiniRepo(
            basicInfo: RepoBasicInfo(
                id: id ?? 0,
                name: name ?? "",
                description: repoDescription ?? ""
            ),
            owner: RepoOwner(
                id: owner?.id ?? 0,
                name: owner?.login ?? "",
                avatar: owner?.avatarURL ?? ""
            )
        )
    }
}
