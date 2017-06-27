//
//  FoodMenuDataSource.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 3/6/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

class FoodMenuDataSource: NSObject, UICollectionViewDataSource {
    let menu: FoodMenu    
    
    init(menu: FoodMenu) {
        self.menu = menu
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "FoodMenuCell"
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FoodMenuCell
        cell.itemName.text = menu.items[indexPath.row].0
        cell.itemPrice.text = menu.items[indexPath.row].1
        return cell
    }
}
