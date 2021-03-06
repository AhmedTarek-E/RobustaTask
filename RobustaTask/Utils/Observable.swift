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
    fileprivate init() {}
    
    var value: T?
    
    func subscribe(observerQueue: ObserverQueue, block: @escaping Subscriber<T>) {
        
    }
    
    func map<R>(_ block: @escaping (_ value: T) -> R) -> Observable<R> {
        let observable = ObservableController<R>()
        subscribe(observerQueue: .same) { value in
            observable.push(value: block(value))
        }
        return observable
    }
    
    func flatMap<R>(_ block: @escaping (_ value: T) -> Observable<R>) -> Observable<R> {
        let observable = ObservableController<R>()
        
        subscribe(observerQueue: .same) { value in
            let newObservable = block(value)
            newObservable.subscribe(observerQueue: .same) { value in
                observable.push(value: value)
            }
        }
        return observable
    }
}

class ObservableController<T> : Observable<T> {
    static func create(block: (Emitter<T>) -> ()) -> Observable<T> {
        let controller = ObservableController()
        let emitter = Emitter(controller: controller)
        block(emitter)
        return controller
    }
    
    override init() {
        
    }
    
    init(value: T?) {
        super.init()
        self.value = value
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
            if let value = value {
                subscriber(value)
            }
        } else {
            subscribers.append(block)
            if let value = value {
                block(value)
            }
        }
        
    }
    
    func push(value: T) {
        self.value = value
        subscribers.forEach { subscriber in
            subscriber(value)
        }
    }
    
}

class Emitter<T> {
    
    init(controller: ObservableController<T>) {
        self.controller = controller
    }
    
    private var controller: ObservableController<T>?
    private var subscribers: [Subscriber<T>] {
        return controller?.subscribers ?? []
    }
    
    func push(value: T) {
        controller?.value = value
        subscribers.forEach { subscriber in
            subscriber(value)
        }
    }
}
