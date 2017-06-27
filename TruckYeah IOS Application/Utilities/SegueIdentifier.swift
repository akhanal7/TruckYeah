//
//  File.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 1/11/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

enum SegueIdentifier { }

protocol SegueIdentifying: RawRepresentable {
    associatedtype DestinationViewController
    
    
    func destination(from segue: UIStoryboardSegue) -> DestinationViewController
}

extension UIViewController {
    func performSegue<T: SegueIdentifying>(withIdentifier identifier: T, sender: Any?) where T.RawValue == String {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func destination<T: SegueIdentifying>(for segue: UIStoryboardSegue, type: T.Type) -> T.DestinationViewController where T.RawValue == String {
        guard let segueCase = segue.identifier.flatMap({ T(rawValue: $0) }) else {
            preconditionFailure("Missing or incorrect segue identifier on \(self): \"\(segue.identifier)\".")
        }
        return segueCase.destination(from: segue)
    }
}
