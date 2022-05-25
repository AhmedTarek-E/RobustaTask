//
//  ReposUseCase.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

protocol ReposUseCase {
    func getRepos(searchKey: String, page: Int) -> Observable<AppResult<[MiniRepo]>>
}

class ReposUseCaseImp: ReposUseCase {
    init(service: GithubRepositoriesService, databaseService: DatabaseService) {
        self.service = service
        self.databaseService = databaseService
    }
    
    private let service: GithubRepositoriesService
    private let databaseService: DatabaseService
    
    func getRepos(searchKey: String, page: Int) -> Observable<AppResult<[MiniRepo]>> {
        return databaseService.fetchRepos(searchKey: searchKey, page: page).flatMap { [weak self] dataRepos in
            guard let self = self else {
                return ObservableController(value: .failure(error: "Unexpected Error"))
            }
            if dataRepos.isEmpty && page == 1 && searchKey.isEmpty {
                return self.service.getRepositories().flatMap { value in
                    switch value {
                    case .success(let data):
                        if !data.isEmpty {
                            return self.databaseService.insert(repos: data).flatMap { _ in
                                return self.getRepos(searchKey: searchKey, page: page)
                            }
                        } else {
                            return ObservableController(value: value)
                        }
                        
                    default:
                        return ObservableController(value: value)
                    }
                    
                }
            } else {
                return ObservableController(value: .success(data: dataRepos))
            }
        }
        
    }
}
