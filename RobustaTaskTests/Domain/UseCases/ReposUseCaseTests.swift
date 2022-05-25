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
    var databaseService: MockDatabaseService!

    override func setUpWithError() throws {
        service = MockGithubRepositoriesService()
        databaseService = MockDatabaseService()
        sut = ReposUseCaseImp(
            service: service,
            databaseService: databaseService
        )
    }

    override func tearDownWithError() throws {
        service.isGetReposCalled = false
        service.isGetRepoDetailsCalled = false
        databaseService.isFetchCalled = false
        databaseService.isInsertCalled = false
    }

    func testWhenGetReposIsCalledThenReturnReposList() {
        let expectation = XCTestExpectation(description: "get repos")
        databaseService.shouldReturnEmpty = {!self.databaseService.isInsertCalled}
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
    
    func testGivenNoReposInDatabaseWhenGetReposCalledThenCallGithubAndSaveToDB() {
        databaseService.shouldReturnEmpty = {!self.databaseService.isInsertCalled}
        
        let expectation = XCTestExpectation(description: "get repos")
        
        let result = sut.getRepos(searchKey: "", page: 1)
        result.subscribe(observerQueue: .same) { value in
           
            XCTAssert(self.service.isGetReposCalled, "Should call getRepos from service")
            
            XCTAssert(self.databaseService.isInsertCalled, "Should insert to Db")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGivenDatabaseHasReposWhenGetReposIsCalledThenOnlyFetchReposSHouldBeCalled() {
        databaseService.shouldReturnEmpty = {false}
        
        let expectation = XCTestExpectation(description: "get repos")
        
        let result = sut.getRepos(searchKey: "", page: 1)
        result.subscribe(observerQueue: .same) { value in
            XCTAssert(self.databaseService.isFetchCalled, "Should fetch from db")
            XCTAssertFalse(self.service.isGetReposCalled, "Shouldnot be call getRepos from service")
            
            XCTAssertFalse(self.databaseService.isInsertCalled, "Should not insert to Db")
            
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
