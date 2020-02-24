//
//  Auth+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 22/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseAuth
import Combine

extension Auth {
    public func updateCurrentUser(_ user: User) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.updateCurrentUser(user) { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func fetchSignInMethods(forEmail email: String) -> AnyPublisher<[String], Error> {
        Future<[String], Error> { [weak self] promise in
            self?.fetchSignInMethods(forEmail: email) { provider, error in
                guard let error = error else {
                    promise(.success(provider ?? []))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func signIn(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func signIn(withEmail email: String, link: String) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.signIn(withEmail: email, link: link) { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    public func signIn(with credential: AuthCredential) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.signIn(with: credential) { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func signInAnonymously() -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.signInAnonymously { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func signIn(withCustomToken token: String) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.signIn(withCustomToken: token) { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func createUser(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { [weak self] promise in
            self?.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func comfirmPasswordReset(withCode code: String, newPassword: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func checkActionCode(_ code: String) -> AnyPublisher<ActionCodeInfo, Error> {
        Future<ActionCodeInfo, Error> { [weak self] promise in
            self?.checkActionCode(code) { info, error in
                if let error = error {
                    promise(.failure(error))
                } else if let info = info {
                    promise(.success(info))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func verifyPasswordResetCode(_ code: String) -> AnyPublisher<String, Error> {
        Future<String, Error> { [weak self] promise in
            self?.verifyPasswordResetCode(code) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func applyActionCode(_ code: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.applyActionCode(code) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func sendPasswordReset(withEmail email: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func sendPasswordReset(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    public func sendSignInLink(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    struct StateDidChangePublisher: Combine.Publisher {
        typealias Output = User?
        typealias Failure = Never
        
        private let auth: Auth
        
        init(_ auth: Auth) {
            self.auth = auth
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, StateDidChangePublisher.Failure == S.Failure, StateDidChangePublisher.Output == S.Input {
            let subscription = User.AuthStateDidChangeSubscription(subcriber: subscriber, auth: auth)
            subscriber.receive(subscription: subscription)
        }
    }
    
    public var stateDidChangePublisher: AnyPublisher<User?, Never> {
        StateDidChangePublisher(self)
            .eraseToAnyPublisher()
    }
    
    fileprivate final class IDTokenDidChangeSubscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == Auth {
        
        var handler: IDTokenDidChangeListenerHandle?
        var auth: Auth?

        init(subcriber: SubscriberType, auth: Auth) {
            self.auth = auth
            handler = auth.addIDTokenDidChangeListener { (auth, _) in
                _ = subcriber.receive(auth)
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }
        
        func cancel() {
            if let handler = handler {
                auth?.removeIDTokenDidChangeListener(handler)
            }
            handler = nil
            auth = nil
        }
    }
    
    struct IDTokenDidChangePublisher: Combine.Publisher {
        typealias Output = Auth
        typealias Failure = Never
        
        private let auth: Auth
        
        init(_ auth: Auth) {
            self.auth = auth
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, IDTokenDidChangePublisher.Failure == S.Failure, IDTokenDidChangePublisher.Output == S.Input {
            let subscription = IDTokenDidChangeSubscription(subcriber: subscriber, auth: auth)
            subscriber.receive(subscription: subscription)
        }
    }
    
    
    public var idTokenDidChangePublisher: AnyPublisher<Auth, Never> {
        IDTokenDidChangePublisher(self)
            .eraseToAnyPublisher()
    }
}

extension User {
    fileprivate final class AuthStateDidChangeSubscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == User? {
        
        var handler: AuthStateDidChangeListenerHandle?
        var auth: Auth?

        init(subcriber: SubscriberType, auth: Auth) {
            self.auth = auth
            handler = auth.addStateDidChangeListener { (_, user) in
                _ = subcriber.receive(user)
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }
        
        func cancel() {
            if let handler = handler {
                auth?.removeStateDidChangeListener(handler)
            }
            handler = nil
            auth = nil
        }
    }
}
