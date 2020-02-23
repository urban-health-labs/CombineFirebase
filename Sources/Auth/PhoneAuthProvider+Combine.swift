//
//  PhoneAuthProvider+Combine.swift
//  CombineFirebase
//
//  Created by Kumar Shivang on 23/02/20.
//  Copyright © 2020 Kumar Shivang. All rights reserved.
//

import FirebaseAuth
import Combine

#if os(iOS)
extension PhoneAuthProvider {
    public func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate? = nil) -> AnyPublisher<String, Error> {
        Future<String, Error> { [weak self] promise in
            self?.verifyPhoneNumber(phoneNumber, uiDelegate: uiDelegate) { result, error in
                if let result = result {
                    promise(.success(result))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
#endif
