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
    init(service: GithubRepositoriesService) {
        self.service = service
    }
    
    private let service: GithubRepositoriesService
    
    func getRepos(searchKey: String, page: Int) -> Observable<AppResult<[MiniRepo]>> {
        return service.getRepositories().map { value in
            if searchKey.count >= 2 {
                switch value {
                case .success(let data):
                    let filtered = data.filter { repo in
                        repo.basicInfo.name.lowercased().contains(searchKey.lowercased())
                    }
                    return .success(data: filtered)
                default:
                    return value
                }
            } else {
                return value
            }
        }
    }
}
