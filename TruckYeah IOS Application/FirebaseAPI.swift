//
//  FirebaseAPI.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 2/12/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Firebase
import Deferred
import FirebaseStorage

class FirebaseAPI {
    
    /// A Task for retriving text data from a certain query of the Firebase database
    /// requires the query in the form of a FIRDatabaseReference.
    func dataTask(_ reference: FIRDatabaseReference) -> Task<FIRDataSnapshot> {
        let deferred = Deferred<TaskResult<FIRDataSnapshot>>()
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            deferred.succeed(with: snapshot)
        }, withCancel: {(error) in
            print("Error on firebase request: \(error)")
            deferred.fail(with: error)
        })
        
        return Task(deferred)
    }
    
    func dataQueryTask(_ query: FIRDatabaseQuery) -> Task<FIRDataSnapshot> {
        let deferred = Deferred<TaskResult<FIRDataSnapshot>>()
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            deferred.succeed(with: snapshot)
        }, withCancel: {(error) in
            print("Error on firebase request: \(error)")
            deferred.fail(with: error)
        })
        
        return Task(deferred)
    }
    
    
    func storageTask(_ reference: FIRStorageReference, destination: URL) -> Task<FIRStorageTaskSnapshot> {
        let deferred = Deferred<TaskResult<FIRStorageTaskSnapshot>>()
        let downloadTask = reference.write(toFile: destination) { url, error in
            if let error = error {
                print("Error downloading \(destination.path) — error: \(error)")
            } else {
                print("local url for image is \(String(describing: url)) — saved")
            }
        }
        downloadTask.observe(.success) { snapshot in
            deferred.succeed(with: snapshot)
        }
        downloadTask.observe(.failure) { snapshot in
            deferred.fail(with: Error.unknown)
        }
    
        return Task(deferred, cancellation: nil)
    }
    
    
    func storageTask(_ reference: FIRStorageReference) -> Task<Data> {
        let deferred = Deferred<TaskResult<Data>>()
        let _ = reference.data(withMaxSize: 12 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed to download profile picture: \(error)")
                // use default image if it failed
                deferred.succeed(with: UIImagePNGRepresentation(#imageLiteral(resourceName: "default_profile"))!)
            } else {
                deferred.succeed(with: data!)
            }
        }
        return Task(deferred, cancellation: nil)
    }
    
    func storageUploadTask(_ reference: FIRStorageReference, destination: URL) {
        
    }
        
    enum Error: Swift.Error {
        case unknown
        
        private var localizedDescription: String {
            switch self {
            case .unknown:
                return "unknown FirebaseAPI.swift error occured"
            }
        }
    }
}
