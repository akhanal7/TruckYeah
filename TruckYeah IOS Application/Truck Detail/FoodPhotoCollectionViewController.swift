//
//  FoodPhotoCollectionViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/16/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

class FoodPhotoCollectionViewController: UICollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "FoodPhotoCell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    override func viewDidLoad() {
        tabBarController?.tabBar.isTranslucent = true
        collectionView?.contentInset = UIEdgeInsets(top: navigationController!.navigationBar.frame.height, left: 0.0, bottom: tabBarController!.tabBar.frame.height, right: 0.0)
    }
}
