//
//  ReposUseCaseTests.swift
//  RobustaTaskTests
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import XCTest
@testable import RobustaTask

class ReposUseCaseTests: XCTestCase {
    
    var sut: ReposUseCase!
    var service: MockGithubRepositoriesService!

    override func setUpWithError() throws {
        service = MockGithubRepositoriesService()
        sut = ReposUseCaseImp(
            service: service
        )
    }

    override func tearDownWithError() throws {
       
    }

    func testWhenGetReposIsCalledThenReturnReposList() {
        let expectation = XCTestExpectation(description: "get repos")
        let result = sut.getRepos(searchKey: "", page: 1)
        result.subscribe(observerQueue: .same) { value in
            switch value {
            case .failure(_):
                XCTAssert(false, "Failed to get repos")
            case .success(data: let data):
                XCTAssert(!data.isEmpty, "Repos are empty")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}