//
//  DatabaseQuery+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseDatabase

public typealias PreviousSiblingKeyDataSnapshot = (snapshot: DataSnapshot, prevKey: String?)

extension DatabaseQuery {
    
    struct Publisher: Combine.Publisher {
        typealias Output = DataSnapshot
        typealias Failure = Error
        
        private let query: DatabaseQuery
        private let eventType: DataEventType
        
        init(_ query: DatabaseQuery, eventType: DataEventType) {
            self.query = query
            self.eventType = eventType
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subcription = DataSnapshot.Subscription(subscriber: subscriber, query: query, eventType: eventType)
            subscriber.receive(subscription: subcription)
        }
    }
    
    public func publisher(eventType: DataEventType) -> AnyPublisher<DataSnapshot, Error> {
        Publisher(self, eventType: eventType)
            .eraseToAnyPublisher()
    }
    
    struct PrevKeyPublisher: Combine.Publisher {
        typealias Output = PreviousSiblingKeyDataSnapshot
        typealias Failure = Error
        
        private let query: DatabaseQuery
        private let eventType: DataEventType
        
        init(_ query: DatabaseQuery, eventType: DataEventType) {
            self.query = query
            self.eventType = eventType
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, PrevKeyPublisher.Failure == S.Failure, PrevKeyPublisher.Output == S.Input {
            let subcription = DataSnapshot.PrevKeySubscription(subscriber: subscriber, query: query, eventType: eventType)
            subscriber.receive(subscription: subcription)
        }
    }
    
    public func prevKeyPublisher(eventType: DataEventType) -> AnyPublisher<PreviousSiblingKeyDataSnapshot, Error> {
        PrevKeyPublisher(self, eventType: eventType)
            .eraseToAnyPublisher()
    }
    
    public func observeSingleEvent(_ eventType: DataEventType) -> AnyPublisher<DataSnapshot, Error> {
        Future<DataSnapshot, Error> { [weak self] promise in
            self?.observeSingleEvent(of: eventType, with: { (snapshot) in
                promise(.success(snapshot))
            }, withCancel: { (error) in
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }
    
    public func observeSingleEventAndPreviousSiblingKey(_ eventType: DataEventType) -> AnyPublisher<PreviousSiblingKeyDataSnapshot, Error> {
        Future<PreviousSiblingKeyDataSnapshot, Error> { [weak self] promise in
            self?.observeSingleEvent(of: eventType, andPreviousSiblingKeyWith: { (snapshot, prevKey) in
                promise(.success(PreviousSiblingKeyDataSnapshot(snapshot, prevKey)))
            }, withCancel: { (error) in
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }
}

extension DataSnapshot {
    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == DataSnapshot, SubscriberType.Failure == Error {
        
        private var query: DatabaseQuery?
        private var handle: DatabaseHandle?
        
        init(subscriber: SubscriberType, query: DatabaseQuery, eventType: DataEventType) {
            self.query = query
            handle = query.observe(eventType, with: { snapshot in
                _ = subscriber.receive(snapshot)
            }, withCancel: { error in
                subscriber.receive(completion: .failure(error))
            })
        }
        
        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }
        
        func cancel() {
            if let handle = handle {
                query?.removeObserver(withHandle: handle)
            }
            handle = nil
            query = nil
        }
    }
    
    fileprivate final class PrevKeySubscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == PreviousSiblingKeyDataSnapshot, SubscriberType.Failure == Error {
        
        private var query: DatabaseQuery?
        private var handle: DatabaseHandle?
        
        init(subscriber: SubscriberType, query: DatabaseQuery, eventType: DataEventType) {
            self.query = query
            handle = query.observe(eventType, andPreviousSiblingKeyWith: { snapshot, prevKey in
                _ = subscriber.receive(PreviousSiblingKeyDataSnapshot(snapshot, prevKey))
            }, withCancel: { error in
                subscriber.receive(completion: .failure(error))
            })
        }
        
        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }
        
        func cancel() {
            if let handle = handle {
                query?.removeObserver(withHandle: handle)
            }
            handle = nil
            query = nil
        }
    }
}

