//
//  Observable.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation

typealias Subscriber<T> = (_ value: T) -> ()

enum ObserverQueue {
    case main
    case same
}

class Observable<T> {
    
    var value: T?
    
    func subscribe(observerQueue: ObserverQueue, block: @escaping Subscriber<T>) {
        
    }
}

class ObservableController<T> : Observable<T> {
    static func create(block: (Emitter<T>) -> ()) -> Observable<T> {
        let controller = ObservableController()
        let emitter = Emitter(controller: controller)
        block(emitter)
        return controller
    }
    
    var subscribers = [Subscriber<T>]()
    
    override func subscribe(observerQueue: ObserverQueue, block: @escaping Subscriber<T>) {
        if (observerQueue == .main) {
            let subscriber: Subscriber<T> = { value in
                DispatchQueue.main.async {
                    block(value)
                }
            }
            subscribers.append(subscriber)
        } else {
            subscribers.append(block)
        }
        
    }
    
    func push(value: T) {
        subscribers.forEach { subscriber in
            subscriber(value)
        }
    }
}

class Emitter<T> {
    
    init(controller: ObservableController<T>) {
        self.controller = controller
    }
    
    private weak var controller: ObservableController<T>?
    private var subscribers: [Subscriber<T>] {
        return controller?.subscribers ?? []
    }
    
    func push(value: T) {
        subscribers.forEach { subscriber in
            subscriber(value)
        }
    }
}
