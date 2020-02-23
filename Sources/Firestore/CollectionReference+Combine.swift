//
//  CollectionReference+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseFirestore

extension CollectionReference {
    
    public func addDocument(data: [String: Any]) -> AnyPublisher<DocumentReference, Error> {
        var ref: DocumentReference?
        return Future<DocumentReference, Error> { [weak self] promise in
            ref = self?.addDocument(data: data) { error in
                if let error = error {
                    promise(.failure(error))
                } else if let ref = ref {
                    promise(.success(ref))
                }
            }
        }.eraseToAnyPublisher()
    }
}
