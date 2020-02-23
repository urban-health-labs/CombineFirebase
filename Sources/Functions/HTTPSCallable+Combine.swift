//
//  HTTPSCallable+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseFunctions

extension HTTPSCallable {
    public func call() -> AnyPublisher<HTTPSCallableResult, Error> {
        Future<HTTPSCallableResult, Error> { [weak self] promise in
            self?.call { result, error in
                if let result = result {
                    promise(.success(result))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func call(_ data: Any?) -> AnyPublisher<HTTPSCallableResult, Error> {
        Future<HTTPSCallableResult, Error> { [weak self] promise in
            self?.call(data) { result, error in
                if let result = result {
                    promise(.success(result))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
