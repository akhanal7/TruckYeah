//
//  Truck.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 11/9/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit

class Truck: CustomStringConvertible {
    var name: String
    var menu: FoodMenu
    var imageName: String
    var localImageURL: URL?
    var backgroundImage: UIImage?
    
    
    init(name: String, menu: FoodMenu, imageName: String) {
        self.name = name
        self.menu = menu
        self.imageName = imageName
    }
    
    var description: String {
        let desc = "Truck: \(name)\nMenu\(menu)"
        return desc
    }
    
}
