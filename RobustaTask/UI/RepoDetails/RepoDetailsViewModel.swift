//
//  RepoDetailsViewModel.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

class RepoDetailsViewModel {
    init(repoDetailsUseCase: RepoDetailsUseCase) {
        self.repoDetailsUseCase = repoDetailsUseCase
    }
    
    private let repoDetailsUseCase: RepoDetailsUseCase
    
    private let stateController = ObservableController<RepoDetailsState>(value: .initial())
    
    var state: Observable<RepoDetailsState> {
        return stateController
    }
    
    private var currentState: RepoDetailsState {
        if let current = state.value {
            return current
        } else {
            fatalError("State can't be nil")
        }
    }
    
    func getRepoDetails(repoId: Int) {
        stateController.push(value: currentState.reduce(details: .loading))
        
        repoDetailsUseCase.getDetails(repoId: repoId)
            .subscribe(observerQueue: .same) { [weak self] value in
                guard let self = self else { return }
                
                switch value {
                case .failure(error: let error):
                    self.stateController.push(
                        value: self.currentState.reduce(
                            details: .failure(error: error))
                    )
                case .success(data: let data):
                    self.stateController.push(
                        value: self.currentState.reduce(
                            details: .success(data: data))
                    )
                }
            }
    }
}
