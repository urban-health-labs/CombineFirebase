//
//  FirebaseExtension.swift
//  CombineFirestore
//
//  Created by Kumar Shivang on 20/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseFirestore
import Combine

extension Query {
    
    struct Publisher: Combine.Publisher {
    
        typealias Output = QuerySnapshot
        typealias Failure = Error
    
        private let query: Query
        private let includeMetadataChanges: Bool
    
        init(_ query: Query, includeMetadataChanges: Bool) {
            self.query = query
            self.includeMetadataChanges = includeMetadataChanges
        }

        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = QuerySnapshot.Subscription(subscriber: subscriber, query: query, includeMetadataChanges: includeMetadataChanges)
            subscriber.receive(subscription: subscription)
        }
    
    }
    
    public func publisher(includeMetadataChanges: Bool = true) -> AnyPublisher<QuerySnapshot, Error> {
        Publisher(self, includeMetadataChanges: includeMetadataChanges)
            .eraseToAnyPublisher()
    }
    
    public func publisher<D: Decodable>(includeMetadataChanges: Bool = true, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper(), querySnapshotMapper: @escaping (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] = QuerySnapshot.defaultMapper()) -> AnyPublisher<[D], Error> {
        publisher(includeMetadataChanges: includeMetadataChanges)
            .map { querySnapshotMapper($0, documentSnapshotMapper) }
            .eraseToAnyPublisher()
    }
    
    public func getDocuments(source: FirestoreSource = .default) -> AnyPublisher<QuerySnapshot, Error> {
        Future<QuerySnapshot, Error> { [weak self] promise in
            self?.getDocuments(source: source, completion: { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                } else {
                    promise(.failure(FirestoreError.nilResultError))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func getDocuments<D: Decodable>(source: FirestoreSource = .default, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper(), querySnapshotMapper: @escaping (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] = QuerySnapshot.defaultMapper()) -> AnyPublisher<[D], Error> {
        getDocuments(source: source)
            .map { querySnapshotMapper($0, documentSnapshotMapper) }
            .eraseToAnyPublisher()
    }
}

extension QuerySnapshot {
    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == QuerySnapshot, SubscriberType.Failure == Error {
        private var registration: ListenerRegistration?

        init(subscriber: SubscriberType, query: Query, includeMetadataChanges: Bool) {
            registration = query.addSnapshotListener (includeMetadataChanges: includeMetadataChanges) { (querySnapshot, error) in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let querySnapshot = querySnapshot {
                    _ = subscriber.receive(querySnapshot)
                } else {
                    subscriber.receive(completion: .failure(FirestoreError.nilResultError))
                }
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
    
    public static func defaultMapper<D: Decodable>() -> (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] {
    { (snapshot, documentSnapshotMapper) in
        var dArray: [D] = []
        snapshot.documents.forEach {
            do {
                if let d = try documentSnapshotMapper($0) {
                    dArray.append(d)
                }
            } catch {
                print("Document snapshot mapper error for \($0.reference.path): \(error)")
            }
        }
        return dArray
        }
    }
}
