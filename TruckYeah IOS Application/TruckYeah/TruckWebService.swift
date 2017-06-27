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
    var allTrucks: [Truck] = [Truck]()  // cache for downloaded trucks
                                        // this should maybe be an NSCache becuase
                                        // each truck stores its background UIImage
    var expired: Bool {
        if let lastLoaded = lastLoaded {
            let deadline = Date(timeIntervalSinceNow: -1200.0)
            return  deadline.compare(lastLoaded) == ComparisonResult.orderedDescending                
        } else {
            return true
        }
    }// Have the trucks been queried too long ago to be consdired invalid?
    var lastLoaded: Date?             // last time the trucks were queried
    
    
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
            self.lastLoaded = Date()
            
            return trucks
        })
        return trucksTask
    }
    
    func fetchSchedule() -> Task<[NSNumber:[DayRange]]> {
               let scheduleRef = ref.child("schedules")
        
        let schedulesTask: Task<[NSNumber:[DayRange]]> = webService.dataTask(scheduleRef).map(upon: DispatchQueue.any(), transform: { (snapshot) -> [NSNumber:[DayRange]] in
            var schedules = [NSNumber:[DayRange]]() // A truck id maps to its array of day ranges
            let allSchedulesArray = snapshot.value as! [Dictionary<String,Any>]
            for s in allSchedulesArray {
                do {
                    let (id, schedule) = try self.unpackSchedule(s)
                    schedules[id] = schedule
                } catch let APIError.MalformedSchedule(badKey: key) {
                    print("Errored parsing schedule on key: \(key)")
                } catch {
                    print("Unexpected error: \(error)")
                    fatalError()
                }
            }
            return schedules
            
        })
        return schedulesTask
    }
    
    private func unpackSchedule(_ s: Dictionary<String, Any>) throws -> (id: NSNumber, schedule: [DayRange]) {
        print(s)
        guard let truckID = s["truckID"] as? NSNumber else {
            throw APIError.MalformedSchedule(badKey: "truckID")
        }
        guard let packed_schedule = s["ranges"] as? [Dictionary<String, [String]>] else {
            throw APIError.MalformedSchedule(badKey: "ranges")
        }
        var schedule = [DayRange]()
        for dayDescription in packed_schedule {
            let day: DayRange.Day
            // get key
            let key = dayDescription.first!.key
            let value = dayDescription.first!.value
            // get value
            switch key {
            case "M":
                day = .Mon
            case "T":
                day = .Tue
            case "W":
                day = .Wed
            case "R":
                day = .Thu
            case "F":
                day = .Fri
            case "S":
                day = .Sat
            case "N":
                day = .Sun
            default:
                fatalError("Bad schedule from the server")
            }
            let timeRange = TimeRange(timeStart: TimeRange.Time(militaryTime:value[0]), timeEnd: TimeRange.Time(militaryTime:value[1]))
            let dayRange = DayRange(timeRange: timeRange , day: day)
            schedule.append(dayRange)
        }
        return (truckID, schedule)
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
        guard let truckID = dict["truckID"] as? NSNumber else {
            throw APIError.MalformedTruck(badKey: "truckID")
        }
        
        return Truck(name: name, menu: menu, imageName: imageName, id: truckID)
    }
    
    
    
    
    private func urlForImage(named imageName: String) -> URL {
        let cacheDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = cacheDirectories.first!
        return cacheDirectory.appendingPathComponent(imageName)
    }
    
    
    enum APIError: Error {
        case MalformedTruck(badKey: String)
        case MalformedSchedule(badKey: String)
    }
}
