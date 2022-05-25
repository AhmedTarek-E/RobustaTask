//
//  RepoDetailsUseCaseTests.swift
//  RobustaTaskTests
//
//  Created by Ahmed Tarek on 25/05/2022.
//

import XCTest
@testable import RobustaTask

class RepoDetailsUseCaseTests: XCTestCase {
    var sut: RepoDetailsUseCase!
    var service: MockGithubRepositoriesService!

    override func setUpWithError() throws {
        service = MockGithubRepositoriesService()
        sut = RepoDetailsUseCaseImp(
            service: service
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenRepoIdWhenGetDetailsIsCalledThenReturnData() {
        let expectation = XCTestExpectation(description: "get repos")
        let result = sut.getDetails(repoId: 1)
        result.subscribe(observerQueue: .same) { value in
            switch value {
            case .failure(_):
                XCTAssert(false, "Failed to get repos")
            case .success(_):
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
