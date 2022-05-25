//
//  DatabaseService.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 25/05/2022.
//

import Foundation

protocol DatabaseService {
    func insert(repos: [MiniRepo]) -> Observable<Void>
    
    func fetchRepos(searchKey: String, page: Int) -> Observable<[MiniRepo]>
}
