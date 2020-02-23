//
//  UserProfileChangeRequest+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseAuth
import Combine

extension UserProfileChangeRequest {
    public func commitChanges() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.commitChanges(completion: { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }
}
