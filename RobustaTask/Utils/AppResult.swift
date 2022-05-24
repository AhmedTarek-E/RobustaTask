//
//  AppResult.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

enum AppResult<T>: Equatable {
    static func == (lhs: AppResult<T>, rhs: AppResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.failure, .failure):
            return true
        case (.success, .success):
            return true
        default:
            return false
        }
    }
    
    case failure(error: String)
    case success(data: T)
    
}
