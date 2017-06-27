//
//  SnapshotEncodable.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/15/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation

protocol SnapshotEncodable {
    func toSnapshot() -> [AnyHashable:Any]
}
