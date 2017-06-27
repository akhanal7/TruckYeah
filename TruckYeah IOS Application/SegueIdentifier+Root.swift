//
//  SegueIdentifier+Root.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 1/20/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

extension SegueIdentifier {
    
    enum Root: String, SegueIdentifying {
        case showAllTrucks
        
        enum ViewController {
            case showAllTrucks(MenuViewController)
        }
        
        func destination(from segue: UIStoryboardSegue) -> ViewController {
            return .showAllTrucks(segue.destination as! MenuViewController)
        }
    }
    
    
    
    
}
