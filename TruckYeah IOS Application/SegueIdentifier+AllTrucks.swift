//
//  SegueIdentifier+Root.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 1/11/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

extension SegueIdentifier {
    
    enum AllTrucks: String, SegueIdentifying {
        case showProfile
        case showTrucks
        case showSettings
        case unwindFromTrucksMenu
        case showFoodMenu
    
        typealias DestinationViewController = ViewController
        
        enum ViewController {
            case showProfile(ProfileViewController)
            case showTrucks(TrucksViewController)
            case showSettings(UIViewController)
            case unwindFromTrucksMenu(LoginViewController)
            case showFoodMenu(UITabBarController)
        }
    
        func destination(from segue: UIStoryboardSegue) -> ViewController {
            switch self {
            case .showProfile:
                return .showProfile(segue.destination as! ProfileViewController)
            case .showTrucks:
                return .showTrucks(segue.destination as! TrucksViewController)
            case .showSettings:
                return .showSettings(segue.destination)
            case .unwindFromTrucksMenu:
                return .unwindFromTrucksMenu(segue.destination as! LoginViewController)
            case .showFoodMenu:
                return .showFoodMenu(segue.destination as! UITabBarController)
            }
        }
    }
}
