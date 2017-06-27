//
//  MenuItemsViewController.swift
//  TruckYeah
//
//  Created by Coulter, Alexis B on 2/1/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import Deferred

class FoodMenuViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var menuDataSource: UICollectionViewDataSource!
    
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        collectionView.dataSource = menuDataSource
        collectionView.delegate = self
        tabBarController?.tabBar.tintColor = UIColor(colorLiteralRed: 207.0/255.0, green: 181.0/255.0, blue: 59.0/255.0, alpha: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for seuge \(String(describing: segue.identifier))")
    }
}

extension FoodMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemsPerRow: CGFloat = 2
        
        let collectionWidth = collectionView.bounds.width - (flowLayout.minimumLineSpacing * itemsPerRow) -
            flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let cellWidth = collectionWidth/itemsPerRow
        let cellHeight: CGFloat = 115.0
        
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView.reloadData()
    }
}
