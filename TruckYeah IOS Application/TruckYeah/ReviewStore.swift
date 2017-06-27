
//  ReviewStore.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/14/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation
import Deferred
import FirebaseDatabase



class ReviewStore {
    private(set) var reviews = [Review]()
    private let client = FirebaseAPI()
    var ref = FIRDatabase.database().reference()
    
    func getReviews(for truckID: NSNumber) -> Task<[Review]> {
        let reviewsQuery =  ref.child("reviews").queryOrdered(byChild: "truckID").queryEqual(toValue: truckID)
        let myTask = client.dataQueryTask(reviewsQuery).map(upon: .any()) { (snapshot) -> [Review] in
            self.reviews = Review.makeReviews(from: snapshot)
            return self.reviews
        }
        return myTask
    }
    
    func addNewReview(_ review: Review, completion: @escaping(Error?) -> Void)  {
        let snapshot = review.toSnapshot()
        let reviewReference = ref.child("reviews")
        let key = reviewReference.childByAutoId().key
        let updates = ["/\(key)": snapshot]
        reviewReference.updateChildValues(updates) { (error, _) in
            completion(error)
        }
    }
}

