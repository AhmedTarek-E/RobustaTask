//
//  GithubRepositoriesService.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

protocol GithubRepositoriesService {
    func getRepositories() -> Observable<AppResult<[MiniRepo]>>
    
    func getRepositoryDetails() -> Observable<AppResult<RepoDetails>>
}
