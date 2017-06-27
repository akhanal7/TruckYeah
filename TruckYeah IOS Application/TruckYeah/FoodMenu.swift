//
//  FoodMenu.swift
//  TruckYeah
//
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import Firebase

class FoodMenu {
    var items: [(String,String)]
    
    init(menu: Dictionary<String, String>) {
        var items = [(String, String)]()
        for (name, price) in menu {
            items.append((name, price))
        }
        self.items = items
    }
}
