//
//  TruckStore.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 11/9/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Deferred

class TruckWebService {
    var ref: FIRDatabaseReference!
    var storage: FIRStorageReference!
    var webService: FirebaseAPI
    var allTrucks: [Truck] = [Truck]()
    var menu = [Dictionary<String,String>]()
    
    init() {
        ref = FIRDatabase.database().reference()
        webService = FirebaseAPI()
        // get a reference to the images folder
        storage = FIRStorage.storage().reference(forURL: "gs://truckyeah-3d80f.appspot.com")
    }
    
    func fetchTrucks() -> Task<[Truck]> {
        var trucks = [Truck]()
        let trucksRef = ref.child("trucks")
        let trucksTask: Task<[Truck]> = webService.dataTask(trucksRef).map(upon: DispatchQueue.any(), transform: {(snapshot) -> [Truck] in
            let trucksDicts = snapshot.value as! [Dictionary<String, Any>]
            for t in trucksDicts {
                do {
                    let truck = try self.unpackTruck(dict: t)
                    trucks.append(truck)
                } catch let APIError.MalformedTruck(badKey: key) {
                    print("Errored parsing truck on key: \(key)")
                } catch {
                    print("Unexpected error: \(error)")
                    fatalError()
                }
            }
            trucksRef.removeAllObservers()
            return trucks
        })
        return trucksTask
    }

    func fetchMenuFor(_ truck: [Truck]) -> [Dictionary<String,String>]{
        
        let trucksRef = ref.child("trucks")
        trucksRef.queryOrdered(byChild: "menu").queryEqual(toValue: menu).observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if snapshot.value is NSNull {
                print("didnt get the menu items")
            } else {
                for child in snapshot.children {
                    let snap = child as! FIRDataSnapshot
                    
                    if snap.value != nil {
                        let key = snap.key
                        let val = snap.value
                        self.menu.append([key:val as! String])
                    }
                    
                   
                }
            }
        })
        return menu
    }
    func fetchImagesFor(_ trucks: [Truck]) -> Task<Void> {
        let lock = NSRecursiveLock()
        var imagesDownloaded = 0
        let deferred = Deferred<TaskResult<Void>>()
        
        for t in trucks {
            let imageURLonDevice = urlForImage(named: t.imageName)
            if FileManager.default.fileExists(atPath: imageURLonDevice.path) {
                t.backgroundImage = UIImage(contentsOfFile: imageURLonDevice.path)
                lock.lock()
                imagesDownloaded += 1
                lock.unlock()
                if imagesDownloaded == trucks.count {
                    deferred.succeed(with: ())
                }
            } else {
                print("downloaded it NICK")
                let imageReference = storage.child("images/\(t.imageName)")
                let _: Task<Void> = webService.storageTask(imageReference, destination: imageURLonDevice).map(upon: DispatchQueue.any(), transform: { (snapshot) in
                    if let e = snapshot.error {
                        print("error downloading image for \(snapshot.reference) — error \(e)")
                    }
                    t.backgroundImage = UIImage(contentsOfFile: imageURLonDevice.path)
                    lock.lock()
                    imagesDownloaded += 1
                    lock.unlock()
                    if imagesDownloaded == trucks.count {
                        deferred.succeed(with: ())
                    }                
                })
            }
        }
        return Task(deferred, cancellation: nil)
    }
    
    func fetchProfileImage(_ imageName: String) -> Task<UIImage> {
        let profileRef = storage.child("profile")
        let imageRef = profileRef.child(imageName)
        let imageTask = webService.storageTask(imageRef).map(upon: DispatchQueue.main, transform: {(data) -> UIImage in
            let image = UIImage(data: data)
            return image!
        })
        return imageTask
    }
    
    func uploadProfileImage(_ imageName: String) {
        
    }
    
    private func unpackTruck(dict: Dictionary<String, Any>) throws -> Truck {
        guard let name = dict["name"] as? String else {
            throw APIError.MalformedTruck(badKey: "name")
        }
        guard let menuDict = dict["Menu"] as? Dictionary<String, String> else {
            throw APIError.MalformedTruck(badKey: "Menu")
        }
        let menu = FoodMenu(menu: menuDict)
        guard let imageName = dict["image"] as? String else {
            throw APIError.MalformedTruck(badKey: "image")
        }
        
        return Truck(name: name, menu: menu, imageName: imageName)
    }
    
    
    
    
    private func urlForImage(named imageName: String) -> URL {
        let cacheDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = cacheDirectories.first!
        return cacheDirectory.appendingPathComponent(imageName)
    }
    
    
    enum APIError: Error {
        case MalformedTruck(badKey: String)
    }
}
