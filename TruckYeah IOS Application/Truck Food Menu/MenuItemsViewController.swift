//
//  MenuItemsViewController.swift
//  TruckYeah
//
//  Created by Coulter, Alexis B on 2/1/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import Deferred

class MenuItemsViewController: UICollectionViewController {
    var truckStore: TruckWebService!
    var menu = [Dictionary<String, String>]()
    
    //how many cells to make
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return 1
            //countMenuItems()
    }
    //create a cell for each menu item & put the name of the menu item as the label
    func collectionview(_collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        let dict = menu[indexPath.row]
        
        cell.itemName.text = dict["Asian Nachos"]
           // dict.index(forKey: "Asian Nachos")
        //cell.itemInfo.title = "test"
        return cell
    }
    
    
    //figure out how many item are in the menu
//    private func countMenuItems() -> Int {
//        let trucks = truckStore.fetchTrucks()
//        let menuDict = truckStore.fetchMenuFor(trucks)
//        print(menuDict)
//        menu = menuDict
//        return menuDict.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) ->UICollectionViewCell {
//        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
//        //have each button transition user to more info screen for the selected item
//    }
}
