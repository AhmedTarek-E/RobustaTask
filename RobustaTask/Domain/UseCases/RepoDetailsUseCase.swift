//
//  RepoDetailsUseCase.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

protocol RepoDetailsUseCase {
    func getDetails(repoId: Int) -> Observable<AppResult<RepoDetails>>
}

class RepoDetailsUseCaseImp: RepoDetailsUseCase {
    init(service: GithubRepositoriesService) {
        self.service = service
    }
    
    let service: GithubRepositoriesService
    
    func getDetails(repoId: Int) -> Observable<AppResult<RepoDetails>> {
        return service.getRepositoryDetails()
    }
}
