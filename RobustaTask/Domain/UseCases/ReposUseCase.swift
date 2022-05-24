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
    func getRepos(page: Int) -> Observable<AppResult<[MiniRepo]>> {
        //TODO: put real implementation
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
