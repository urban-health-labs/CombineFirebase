//
//  DocumentReference+Combine.swift
//  UrbanYogi_2
//
//  Created by Kumar Shivang on 21/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseFirestore
import Combine

extension DocumentReference {
    
    struct Publisher: Combine.Publisher {
    
        typealias Output = DocumentSnapshot?
        typealias Failure = Never
    
        private let documentReference: DocumentReference
        private let includeMetadataChanges: Bool
    
        init(_ documentReference: DocumentReference, includeMetadataChanges: Bool) {
            self.documentReference = documentReference
            self.includeMetadataChanges = includeMetadataChanges
        }

        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = DocumentSnapshot.Subscription(subscriber: subscriber, documentReference: documentReference, includeMetadataChanges: includeMetadataChanges)
            subscriber.receive(subscription: subscription)
        }
    }
    
    func publisher(includeMetadataChanges : Bool = true) -> AnyPublisher<DocumentSnapshot?, Never> {
        Publisher(self, includeMetadataChanges: includeMetadataChanges)
            .eraseToAnyPublisher()
    }
    
    func future(source: FirestoreSource = .default) -> AnyPublisher<DocumentSnapshot, Error> {
        Future<DocumentSnapshot, Error> { [weak self] promise in
            self?.getDocument(source: source, completion: { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                } else {
                    promise(.failure(FirebaseError.nilResultError))
                }
            })
        }.eraseToAnyPublisher()
    }
}

extension DocumentSnapshot {
    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == DocumentSnapshot? {
        private var registration: ListenerRegistration?

        init(subscriber: SubscriberType, documentReference: DocumentReference, includeMetadataChanges: Bool) {
            registration = documentReference.addSnapshotListener (includeMetadataChanges: includeMetadataChanges) { (snapshot, error) in
                _ = subscriber.receive(snapshot)
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            registration?.remove()
            registration = nil
        }
    }
}
