//
//  SnapshotDecodable.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/14/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol SnapshotDecodable {
    init?(with snapshot: FIRDataSnapshot) throws
}

extension FIRDataSnapshot {
    enum Error: Swift.Error {
        case malformedData
        case noData
    }
}
