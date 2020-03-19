//
//  StorageObservableTask+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseStorage

extension StorageObservableTask {
    
    struct Publisher: Combine.Publisher {
        typealias Output = StorageTaskSnapshot
        typealias Failure = Never
        
        private let task: StorageObservableTask
        private let status: StorageTaskStatus
        
        init(_ task: StorageObservableTask, status: StorageTaskStatus) {
            self.task = task
            self.status = status
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = StorageTaskSnapshot.Subscription(subscriber: subscriber, task: task, status: status)
            subscriber.receive(subscription: subscription)
        }
    }
    
    public func publisher(_ status: StorageTaskStatus) -> AnyPublisher<StorageTaskSnapshot, Never> {
        Publisher(self, status: status)
            .eraseToAnyPublisher()
    }
    
}

extension StorageTaskSnapshot {
    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == StorageTaskSnapshot {
        
        private var task: StorageObservableTask?
        private var handle: String?
        
        init(subscriber: SubscriberType, task: StorageObservableTask, status: StorageTaskStatus) {
            self.task = task
            handle = task.observe(status) { snapshot in
                _ = subscriber.receive(snapshot)
            }
        }
        
        func cancel() {
            if let handle = handle {
                task?.removeObserver(withHandle: handle)
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
        }
    }
}

