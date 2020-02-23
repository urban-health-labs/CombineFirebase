//
//  DatabaseReference+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseDatabase

public typealias DatabaseReferenceTransactionResult = (committed: Bool, snapshot: DataSnapshot?)

extension DatabaseReference {
    
    public func setValue(_ value: Any?, andPriority priority: Any? = nil) -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.setValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func removeValue() -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.removeValue(completionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func setPriority(_ priority: Any?) -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.setPriority(priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func updateChildValues(_ values: [AnyHashable: Any]) -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func onDisconnectSetValue(_ value: Any?, andPriority priority: Any? = nil) -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.onDisconnectSetValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func onDisconnectRemoveValue() -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.onDisconnectRemoveValue(completionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func onDisconnectUpdateChildValues(_ values: [AnyHashable: Any]) -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.onDisconnectUpdateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func cancelDisconnectOperations() -> AnyPublisher<DatabaseReference, Error> {
        Future<DatabaseReference, Error> { [weak self] promise in
            self?.cancelDisconnectOperations(completionBlock: { (error, ref) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(ref))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func runTransactionBlock(_ block: @escaping (MutableData) -> TransactionResult, withLocalEvents: Bool = true) -> AnyPublisher<DatabaseReferenceTransactionResult, Error> {
        Future<DatabaseReferenceTransactionResult, Error> { [weak self] promise in
            self?.runTransactionBlock(block, andCompletionBlock: { (error, committed, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(DatabaseReferenceTransactionResult(committed, snapshot)))
                }
            })
        }.eraseToAnyPublisher()
    }
}
