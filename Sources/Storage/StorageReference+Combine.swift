//
//  StorageReference+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import Combine
import FirebaseStorage
import Foundation

extension StorageReference {
    
    public func putData(_ uploadData: Data, metadata: StorageMetadata? = nil) -> AnyPublisher<StorageMetadata, Error> {
        var task: StorageUploadTask?
        return Future<StorageMetadata, Error> { [weak self] promise in
            task = self?.putData(uploadData, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        promise(.success(metadata))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    public func putFile(from url: URL, metadata: StorageMetadata? = nil) -> AnyPublisher<StorageMetadata, Error> {
        var task: StorageUploadTask?
        return Future<StorageMetadata, Error> { [weak self] promise in
            task = self?.putFile(from: url, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        promise(.success(metadata))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    public func getData(maxSize: Int64) -> AnyPublisher<Data, Error> {
        var task: StorageDownloadTask?
        return Future<Data, Error> { [weak self] promise in
            task = self?.getData(maxSize: maxSize) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        promise(.success(metadata))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    public func downloadURL() -> AnyPublisher<URL, Error> {
        Future<URL, Error> { [weak self] promise in
            self?.downloadURL { url, error in
                guard let error = error else {
                    if let url = url {
                        promise(.success(url))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func write(toFile url: URL) -> AnyPublisher<URL, Error> {
        var task: StorageDownloadTask?
        return Future<URL, Error> { [weak self] promise in
            task = self?.write(toFile: url) { url, error in
                guard let error = error else {
                    if let url = url {
                        promise(.success(url))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    public func getMetadata() -> AnyPublisher<StorageMetadata, Error> {
        Future<StorageMetadata, Error> { [weak self] promise in
            self?.getMetadata { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        promise(.success(metadata))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func updateMetadata(_ metadata: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        Future<StorageMetadata, Error> { [weak self] promise in
            self?.updateMetadata(metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        promise(.success(metadata))
                    }
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func delete() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
