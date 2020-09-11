# CombineFirebase

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-informational)](#swift-package-manager)
[![Version](https://img.shields.io/cocoapods/v/CombineFirebase.svg?style=flat)](https://cocoapods.org/pods/CombineFirebase)
[![License](https://img.shields.io/cocoapods/l/CombineFirebase.svg?style=flat)](https://cocoapods.org/pods/CombineFirebase)
[![Platform](https://img.shields.io/cocoapods/p/CombineFirebase.svg?style=flat)](https://cocoapods.org/pods/CombineFirebase)

Handling [Firebase](https://github.com/firebase/firebase-ios-sdk) asynchronous callbacks with [Combine](https://developer.apple.com/documentation/combine) framework.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. See [Usage](#Usage) below for more information.

## Requirements

* Xcode 11.3+ | Swift 5.1+
* iOS 13.0+ | tvOS 13.0+ | macOS 10.15+

## Installation

#### CocoaPods

`CombineFirebase` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

``` ruby
pod 'CombineFirebase/Firestore'
pod 'CombineFirebase/RemoteConfig'
pod 'CombineFirebase/Database'
pod 'CombineFirebase/Storage'
pod 'CombineFirebase/Auth'
pod 'CombineFirebase/Functions'
```

#### Swift Package Manager

`CombineFirebase` is available through [Swift Package Manager](https://swift.org/package-manager/) in beta status. To install it, you must have **Xcode 12.0** and above, simply add `CombineFirebase` to an existing Xcode project as a package dependency:

1. From the **File** menu, select **Swift Packages > Add Package Dependency...**
2. Enter https://github.com/rever-ai/CombineFirebase into the package repository URL text field.
3. Xcode should choose updates package up to the next version option by default.

## Usage

``` swift
import CombineFirebase
import Firebase
import Combine
```

* [Database](#database)
* [Firestore](#firestore)
* [RemoteConfig](#remoteconfig)
* [Storage](#storage)
* [Auth](#auth)
* [Functions](#functions)

### Database

Basic write operation

``` swift
var cancelBag = Set<AnyCancellable>()

func setUserData() {
    let ref = Database.database().reference()

    ref.child("users")
        .child("1")
        .setValue(["username": "Arnonymous"])
        .sink { _ in
            print("Document successfully updated")
        }.store(in: &cancelBag)
}

// https://firebase.google.com/docs/database/ios/read-and-write#basic_write
```

Listen for value events

``` swift
var cancelBag = Set<AnyCancellable>()

func listenForValueEvent() {
    let ref = Database.database().reference()

    ref.child("users")
        .child("1")
        .publisher(.value)
        .receive(on: RunLoop.main)
        .sink { snapshot in
            print("Value:\(snapshot.value)")
        }.store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/database/ios/read-and-write#listen_for_value_events
```

Read data once

``` swift
var cancelBag = Set<AnyCancellable>()

func readDataOnce() {
    let ref = Database.database().reference()

    ref.child("users")
        .child("1")
        .observeSingleEvent(.value)
        .receive(on: RunLoop.main)                
        .sink { snapshot in
            print("Value:\(snapshot.value)")
        }.store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/database/ios/read-and-write#read_data_once
```

Update specific fields

``` swift
var cancelBag = Set<AnyCancellable>()

func updateFields() {
    let ref = Database.database().reference()

    let childUpdates = ["/posts/\(key)": post,
                        "/user-posts/\(userID)/\(key)/": post]
    ref.updateChildValues(childUpdates)
        .receive(on: RunLoop.main)
        .sink { _ in
            // Success
        }.store(in: &cancelBag)
}

// https://firebase.google.com/docs/database/ios/read-and-write#update_specific_fields
```

Delete data

``` swift
var cancelBag = Set<AnyCancellable>()

func deleteData() {
    let ref = Database.database().reference()

    ref.removeValue()
        .receive(on: RunLoop.main)    
        .sink { _ in
            // Success
        }.store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/database/ios/read-and-write#delete_data
```

Save data as transactions

``` swift
var cancelBag = Set<AnyCancellable>()

func saveDataAsTransaction() {
    let ref = Database.database().reference()

    ref.runTransactionBlock { currentData in
            // TransactionResult
        }.sink { _ in
            // Success
        }.store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/database/ios/read-and-write#save_data_as_transactions
```

### Firestore

Setting data

``` swift
var cancelBag = Set<Cancellable>()

let db = Firestore.firestore()

struct City: Codable {
    var name: String? = nil
    var state: String? = nil
    var country: String? = nil
    var capital: String? = nil
    var population: Int? = nil
    
    // local variable 
    var id: String? = nil
}

func setSanFranciscoData(city: City) {
    let onErrorCompletion: ((Subscribers.Completion<Error>) -> Void)? = { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): print("❗️ failure: \(error)")
        }
    }

    let onValue: (Void) -> Void = {
        print("✅ value")
    }

    // Add a new document in collection "cities"
    (db.collection("cities")
        .document("SF")
        .setData(from: city) as AnyPublisher<Void, Error>) // Note: you can use (as Void) for simple setData({})
            .sink(receiveCompletion: onErrorCompletion, receiveValue: onValue)
            .store(in: &cancelBag)
}
       
// Add a new document with a generated id.
func addSanFranciscoDocument(city: City) {
    (db.collection("cities")
        .addDocument(data: [
            "name": "San Francisco",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 860000
            ]) as AnyPublisher<DocumentReference, Error>)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }) { ref in
                print("Document added with ID: \(ref.documentID)")
            }
            .store(in: &cancelBag)            
}
        
// Set the "capital" field of the city 'SF'
func updateSanFranciscoDocument() {
    (db.collection("cities")
        .document("SF")
        .updateData([
            "capital": true
            ]) as AnyPublisher<Void, Error>)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print(i"❗️ failure: \(error)")
            }) { _ in }
            .store(in: &cancelBag)
}
        
// https://firebase.google.com/docs/firestore/manage-data/add-data
```

Get a document

``` swift
func getDocument() {
    db.collection("cities")
        .document("SF")
        .getDocument()
        .sink(receiveCompletion: { (completion) in
               switch completion {
               case .finished: print("🏁 finished")
               case .failure(let error): print("❗️ failure: \(error)")
               }
           }) { document in
               print("Document data: \(document.data())")
        }
        .store(in: &cancelBag)
}

func getDocumentAsObject() {
    db.collection("cities")
        .document("SF")
        .getDocument(as: City.self)
        .sink(receiveCompletion: { (completion) in
               switch completion {
               case .finished: print("🏁 finished")
               case .failure(let error): print("❗️ failure: \(error)")
               }
           }) { city in
               print("City: \(city)")
        }
        .store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/firestore/query-data/get-data
```

Get Realtime updates

``` swift
let db = Firestore.firestore()

// Document
func listenDocument() {
    db.collection("cities")
        .document("SF")
        .publisher()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { document in
            print("Document data: \(document.data())")
        }
        .store(in: &cancelBag)
}

var cityDocumentSnapshotMapper: (DocumentSnapshot) throws -> City? {
    {
        var city =  try $0.data(as: City.self)
        city.id = $0.documentID
        return city
    }
}

func listenDocumentAsObject() {
    db.collection("cities")
        .document("SF")
        .publisher(as: City.self, documentSnapshotMapper: cityDocumentSnapshotMapper)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { city in
            print("City: \(city)")
        }
        .store(in: &cancelBag)
}

    
// Collection
func listenCollection() {
    db.collection("cities")
        .publisher()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { snapshot in
            print("collection data: \(snapshot.documents)")
        }.store(in: &cancelBag)
}

func listenCollectionAsObject() {
    db.collection("cities")
        .publisher(as: City.self, documentSnapshotMapper: cityDocumentSnapshotMapper)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { cities in
            print("Cities: \(cities)")
        }.store(in: &cancelBag)
}

// https://firebase.google.com/docs/firestore/query-data/listen
```

Batched writes

``` swift
var cancelBag = Set<AnyCancellable>()

func batchWrite() {
    let db = Firestore.firestore()

    // Get new write batch
    let batch = db.batch()

    // Update the population of 'SF'
    let sfRef = db.collection("cities").document("SF")
    batch.updateData(["population": 1000000 ], forDocument: sfRef)

    // Commit the batch
    batch.commit()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { _ in}
        .store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/firestore/manage-data/transactions
```

Transactions

``` swift
var cancelBag = Set<AnyCancellable>()

func transaction() {
    let db = Firestore.firestore()
    let sfReference = db.collection("cities").document("SF")

    (db.runTransaction { transaction in
        let sfDocument = try transaction.getDocument(sfReference)
        
        guard let oldPopulation = sfDocument.data()?["population"] as? Int else {
            let error = NSError(
                domain: "AppErrorDomain",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                ]
            )
            throw error
        }
        
        transaction.updateData(["population": oldPopulation + 1], forDocument: sfReference)
        return nil
        } as AnyPublisher<Any?, Error>)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { _ in
            print("Transaction successfully committed!")
        }
        .store(in: &cancelBag)
}
    
// https://firebase.google.com/docs/firestore/manage-data/transactions
```

### RemoteConfig

Fetch

``` swift
// TimeInterval is set to expirationDuration here, indicating the next fetch request will use
// data fetched from the Remote Config service, rather than cached parameter values, if cached
// parameter values are more than expirationDuration seconds old. See Best Practices in the
// README for more information.

var cancelBag = Set<AnyCancellable>()

func fetchRemoteConfig() {
    (RemoteConfig.remoteConfig()
        .fetch(withExpirationDuration: TimeInterval(expirationDuration), activateFetched: true) as AnyPublisher<RemoteConfigFetchStatus, Error>)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { status in
            print("Config fetched! with success:\(status == .success)")
        }
       .store(in: &cancelBag)
}

// https://firebase.google.com/docs/remote-config/ios
```

### Storage

Upload

``` swift
var cancelBag = Set<AnyCancellable>()

let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")
    
let data: Data // Upload data
(reference.putData(data) as AnyPublisher<StorageMetadata, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { metadata in
        // Success         
    }
    .store(in: &cancelBag)
    

let fileURL: URL // Upload file
(reference.putFile(from: fileURL) as AnyPublisher<StorageMetadata, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { metadata in
       // Success         
    }
    .store(in: &cancelBag)
```

Observe events

``` swift
var cancelBag = Set<AnyCancellable>()
let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")

let fileURL: URL // Upload file
let uploadTask = reference.putFile(from: fileURL)

// Listen for state changes
uploadTask.publisher(.progress)
    .sink(receiveCompletion: { _ in
        print("🏁 finished")
    }) { snapshot in
        if let error = snapshot.error {
            print("error: \(error)")
        }
        // Upload reported progress
        let percentComplete = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0)
                                    / Double(snapshot.progress.totalUnitCount ?? 1)
   }
   .store(in: &cancelBag)
```

Download

``` swift
var cancelBag = Set<AnyCancellable>()
let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")

// Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
(reference.getData(maxSize: 1 * 1024 * 1024) as AnyPublisher<Data, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { data in
       // Data for "images/space.jpg" is returned
    }
    .store(in: &cancelBag)
    
// Create local filesystem URL
let localURL = URL(string: "path/to/image")!
    
// Download to the local filesystem
(reference.write(toFile: localURL) as AnyPublisher<URL, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { data in
       // Local file URL for "images/space.jpg" is returned
    }
    .store(in: &cancelBag)
```

URL

``` swift
var cancelBag = Set<AnyCancellable>()
let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")
    
// Fetch the download URL
(reference.downloadURL() as AnyPublisher<URL, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { data in
        // Get the download URL for 'images/space.jpg'       
    }
    .store(in: &cancelBag)
```

Metadata

``` swift
var cancelBag = Set<AnyCancellable>()
let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")
    
// Create file metadata to update
let newMetadata = StorageMetadata()
    
// Update metadata properties
(reference.updateMetadata(newMetadata) as AnyPublisher<StorageMetadata, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { metadata in
        // Updated metadata for 'images/space.jpg' is returned        
    }
    .store(in: &cancelBag)
    
// Get metadata properties
(reference.getMetadata() as AnyPublisher<StorageMetadata, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { metadata in
        // Metadata now contains the metadata for 'images/space.jpg'
    }
    .store(in: &cancelBag)
```

Delete

``` swift
var cancelBag = Set<AnyCancellable>()
let reference = Storage.storage()
    .reference(forURL: "\(your_firebase_storage_bucket)/images/space.jpg")
    
// Delete the file
(reference.delete() as AnyPublisher<Void, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { _ in
        // File deleted successfully    
    }
    .store(in: &cancelBag)
```

### Auth

Create

``` swift
var cancelBag = Set<AnyCancellable>()
let auth = Auth.auth()
    
// Create a password-based account
(auth.createUser(withEmail: "xxx@xxx.com", password: "1q2w3e4r") as AnyPublisher<AuthDataResult, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { _ in
        // User signed in
    }.store(in: &cancelBag)

// https://firebase.google.com/docs/auth/ios/password-auth
```

Sign in

``` swift
var cancelBag = Set<AnyCancellable>()

let auth = Auth.auth()
    
// Sign in a user with an email address and password
(auth.signIn(withEmail: "xxx@xxx.com", password: "1q2w3e4r") as AnyPublisher<AuthDataResult, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { _ in
        // User signed in
    }.store(in: &cancelBag)

// https://firebase.google.com/docs/auth/ios/password-auth
```

#### User

Update email

``` swift
var cancelBag = Set<AnyCancellable>()
let user = Auth.auth().currentUser
    
// Set a user's email address
(user.updateEmail(to: "xxx@xxx.com") as AnyPublisher<Void, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { _ in
        // Completed updating Email         
    }.store(in: &cancelBag)

// https://firebase.google.com/docs/auth/ios/manage-users
```

Delete

``` swift
var cancelBag = Set<AnyCancellable>()
let user = Auth.auth().currentUser

// Delete a user
(user.delete() as AnyPublisher<Void, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): // Uh-oh, an error occurred! 
        }
    }) { _ in
        // User deleted
    }.store(in: &cancelBag)

// https://firebase.google.com/docs/auth/ios/manage-users
```

### Functions

``` swift
var cancelBag = Set<AnyCancellable>()
let functions = Functions.functions()
let request = functions.httpsCallable("functionName")

(request
    .call(["parameter": "value"]) as AnyPublisher<HTTPSCallableResult, Error>)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): print("error:\(error)")
        }
    }) { result in
         print("response:\(result)")
    }.store(in: &cancelBag)
    
// https://firebase.google.com/docs/functions/callable#call_the_function
```

## Author

Kumar Shivang, shivang.iitk@gmail.com

## License

CombineFirebase is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
