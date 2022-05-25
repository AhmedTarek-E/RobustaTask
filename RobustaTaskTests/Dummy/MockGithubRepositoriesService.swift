//
//  MockGithubRepositoriesService.swift
//  RobustaTaskTests
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation
@testable import RobustaTask

class MockGithubRepositoriesService: GithubRepositoriesService {
    var isGetRepoDetailsCalled = false
    var isGetReposCalled = false
    
    func getRepositoryDetails(repoId: Int) -> Observable<AppResult<RepoDetails>> {
        isGetRepoDetailsCalled = true
        return ObservableController.create { emitter in
            emitter.push(
                value: .success(
                    data: RepoDetails(
                        basicInfo: RepoBasicInfo(
                            id: 1,
                            name: "RxSwift",
                            description: "Best RxSwift"
                        ),
                        owner: RepoOwner(
                            id: 1,
                            name: "RxTeam",
                            avatar: "https://assets.goal.com/v3/assets/bltcc7a7ffd2fbf71f5/blt8e1f444328de56ec/627ff3ee9154c30583900892/20220514_Robert_Lewandowski.jpg?auto=webp&format=jpg&quality=100"
                        ),
                        createdAt: Date.now,
                        size: 1024,
                        watchersCount: 4,
                        forksCount: 67,
                        language: "Ruby",
                        openIssuesCount: 31,
                        license: "MIT",
                        defaultBranch: "main"
                    )
                )
            )
        }
    }
    
    func getRepositories() -> Observable<AppResult<[MiniRepo]>> {
        isGetReposCalled = true
        return ObservableController.create { emitter in
            emitter.push(
                value: .success(
                    data: [
                        MiniRepo(
                            basicInfo: RepoBasicInfo(
                                id: 1,
                                name: "RxSwift",
                                description: "Best RxSwift"
                            ),
                            owner: RepoOwner(
                                id: 1,
                                name: "RxTeam",
                                avatar: "https://assets.goal.com/v3/assets/bltcc7a7ffd2fbf71f5/blt8e1f444328de56ec/627ff3ee9154c30583900892/20220514_Robert_Lewandowski.jpg?auto=webp&format=jpg&quality=100")
                        )
                    ]
                )
            )
        }
    }
    
    
}
