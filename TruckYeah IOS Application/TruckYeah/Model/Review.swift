//
//  Review.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/14/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Review {
    let author: String
    let reviewText: String
    let truckID: NSNumber
    let title: String
}

extension Review: SnapshotDecodable, SnapshotEncodable {
    
    init?(with snapshot: FIRDataSnapshot)  {
        guard let reviewDict = snapshot.value as? Dictionary<String, Any> else {
            return nil
        }
        
        guard let author = reviewDict["author"] as? String,
        let truckID =  reviewDict["truckID"] as? NSNumber,
        let title =  reviewDict["reviewTitle"] as? String,
            let reviewText =  reviewDict["reviewText"] as? String else {
               return nil
        }
        self.author = author
        self.truckID = truckID
        self.title = title
        self.reviewText = reviewText
    }
    
    init?(with reviewDict: Dictionary<String, Any>)  {
        
        guard let author = reviewDict["author"] as? String,
            let truckID =  reviewDict["truckID"] as? NSNumber,
            let title =  reviewDict["reviewTitle"] as? String,
            let reviewText =  reviewDict["reviewText"] as? String else {
                return nil
        }
        self.author = author
        self.truckID = truckID
        self.title = title
        self.reviewText = reviewText
    }
    
    static func makeReviews(from snapshot: FIRDataSnapshot) -> [Review] {
        guard let incomingDict = snapshot.value as? [AnyHashable: Dictionary<String,Any>?] else {
            return []
        }
        var reviews = [Review]()
        for (_, d) in incomingDict {
            guard d != nil else {
                continue
            }
            if let decodedeReview = Review(with: d!) {
                reviews.append(decodedeReview)
            }
        }
        return reviews
    }
    
    func toSnapshot() -> [AnyHashable: Any] {
        var snapshotData = [AnyHashable:Any]()
        snapshotData["author"] = author
        snapshotData["reviewText"] = reviewText
        snapshotData["truckID"] = truckID
        snapshotData["reviewTitle"] = title
        return snapshotData
    }
}
