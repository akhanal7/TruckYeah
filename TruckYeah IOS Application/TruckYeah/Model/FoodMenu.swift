//
//  FoodMenu.swift
//  TruckYeah
//
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import Firebase

class FoodMenu {
    var items: Dictionary<String,String>
    
    init(menu: Dictionary<String, String>) {
        items = menu
    }
}
