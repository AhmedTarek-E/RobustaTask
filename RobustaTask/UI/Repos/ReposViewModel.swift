//
//  ReposViewModel.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

class ReposViewModel {
    init(reposUseCase: ReposUseCase) {
        self.reposUseCase = reposUseCase
    }
    
    private let reposUseCase: ReposUseCase
    
    private let stateController = ObservableController<ReposState>(value: ReposState.initial())
    
    var state: Observable<ReposState> {
        return stateController
    }
    
    private var currentState: ReposState {
        if let current = state.value {
            return current
        } else {
            fatalError("State can't be nil")
        }
    }
    
    //TODO pagination
    func getRepos(searchKey: String, page: Int) {
        stateController.push(value: currentState.reduce(repos: .loading))
        reposUseCase.getRepos(searchKey: searchKey, page: 1).subscribe(
            observerQueue: .same) { [weak self] value in
                guard let self = self else { return }
                
                switch value {
                case .failure(error: let error):
                    self.stateController.push(
                        value: self.currentState.reduce(
                            repos: .failure(error: error))
                    )
                case .success(data: let data):
                    self.stateController.push(
                        value: self.currentState.reduce(
                            repos: .success(data: data))
                    )
                }
            }
    }
}
