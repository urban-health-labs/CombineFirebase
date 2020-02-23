//
//  User+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseAuth
import Combine

extension User {
    
    public func updateEmail(to email: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.updateEmail(to: email, completion: { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }
    
    
    public func updatePassword(to password: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.updatePassword(to: password, completion: { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }
    
    
    #if os(iOS)
    public func updatePhoneNumber(_ credential: PhoneAuthCredential) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.updatePhoneNumber(credential) { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    #endif
    
    public func reload() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.reload() { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func reauthenticate(with credential: AuthCredential) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.reauthenticate(with: credential) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getIdTokenResult() -> AnyPublisher<AuthTokenResult, Error> {
        Future<AuthTokenResult, Error> { [weak self] promise in
            self?.getIDTokenResult { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getIdTokenResult(forcingRefresh: Bool) -> AnyPublisher<AuthTokenResult, Error> {
        Future<AuthTokenResult, Error> { [weak self] promise in
            self?.getIDTokenResult(forcingRefresh: forcingRefresh) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getIDToken() -> AnyPublisher<String, Error> {
        Future<String, Error> { [weak self] promise in
            self?.getIDToken { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getIDToken(_ forceRefresh: Bool) -> AnyPublisher<String, Error> {
        Future<String, Error> { [weak self] promise in
            self?.getIDTokenForcingRefresh(forceRefresh) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func link(with credential: AuthCredential) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.link(with: credential) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    public func unlink(fromProvider provider: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { [weak self] promise in
            self?.unlink(fromProvider: provider) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func sendEmailVerification() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func sendEmailVerification(with settings: ActionCodeSettings) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.sendEmailVerification(with: settings) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
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
