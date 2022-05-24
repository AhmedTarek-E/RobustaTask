//
//  ReposUseCase.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

protocol ReposUseCase {
    func getRepos(page: Int) -> Observable<AppResult<[MiniRepo]>>
}

class ReposUseCaseImp: ReposUseCase {
    init(service: GithubRepositoriesService) {
        self.service = service
    }
    
    let service: GithubRepositoriesService
    
    func getRepos(page: Int) -> Observable<AppResult<[MiniRepo]>> {
        return service.getRepositories()
    }
}
