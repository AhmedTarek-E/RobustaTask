//
//  GithubRepositoriesServiceImp.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

class GithubRepositoriesServiceImp: GithubRepositoriesService {
    
    let httpClient = HttpRequestClient.shared
    
    func getRepositories() -> Observable<AppResult<[MiniRepo]>> {
        return ObservableController.create { emitter in
            if let url = URL(string: "https://api.github.com/repositories") {
                httpClient.sendRequest(url: url) { result in
                    switch result {
                    case .failure(error: let error):
                        emitter.push(value: .failure(error: error))
                    case .success(data: let data):
                        let parsed = (try? JSONDecoder().decode(APIRepositoriesResult.self, from: data)) ?? []

                        emitter.push(value: .success(data: parsed.map({ item in
                            return item.map()
                        })))
                    }
                }
            } else {
                emitter.push(value: .failure(error: "Failed to send request"))
            }
            
        }
    }
    
    func getRepositoryDetails(repoId: Int) -> Observable<AppResult<RepoDetails>> {
        return ObservableController.create { emitter in
            if let url = URL(string: "https://api.github.com/repositories/\(repoId)") {
                httpClient.sendRequest(url: url) { result in
                    switch result {
                    case .failure(error: let error):
                        emitter.push(value: .failure(error: error))
                    case .success(data: let data):
                        do {
                            let parsed = try JSONDecoder().decode(APIRepositoryDetailsResult.self, from: data)
                            
                            emitter.push(value: .success(data: parsed.map()))
                            
                        } catch let error {
                            print(error)
                            emitter.push(value: .failure(error: "Failed to read response"))
                        }
                        
                        
                    }
                }
            } else {
                emitter.push(value: .failure(error: "Failed to send request"))
            }
        }
    }
}
