//
//  ReposState.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

struct ReposState {
    static func initial() -> ReposState {
        return ReposState(
            repos: .initial
        )
    }
    
    init(repos: Asyncronous<[MiniRepo]>) {
        self.repos = repos
    }
    
    let repos: Asyncronous<[MiniRepo]>
    
    func reduce(
        repos: Asyncronous<[MiniRepo]>?
    ) -> ReposState {
        return ReposState(
            repos: repos ?? self.repos
        )
    }
}
