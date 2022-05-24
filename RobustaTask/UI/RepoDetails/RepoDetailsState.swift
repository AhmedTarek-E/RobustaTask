//
//  RepoDetailsState.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

struct RepoDetailsState {
    static func initial() -> RepoDetailsState {
        return RepoDetailsState(details: .initial)
    }
    init(details: Asyncronous<RepoDetails>) {
        self.details = details
    }
    
    let details: Asyncronous<RepoDetails>
    
    func reduce(
        details: Asyncronous<RepoDetails>?
    ) -> RepoDetailsState {
        return RepoDetailsState(
            details: details ?? self.details
        )
    }
}
