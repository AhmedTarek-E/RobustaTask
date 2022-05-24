//
//  Asyncronous.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

enum Asyncronous<T> {
    case initial
    case loading
    case failure(error: String)
    case success(data: T)
}
