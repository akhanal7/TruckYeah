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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodPhotoCell", for: indexPath)
        let i = indexPath.row + 1 
        let imageString = String(format: "%04d.pjg", i)
        
        let imageView = UIImageView(image: UIImage(named: imageString))
        imageView.contentMode = .scaleAspectFit
        
        cell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": imageView]))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": imageView]))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    override func viewDidLoad() {
        tabBarController?.tabBar.isTranslucent = true
        collectionView?.contentInset = UIEdgeInsets(top: navigationController!.navigationBar.frame.height, left: 0.0, bottom: tabBarController!.tabBar.frame.height, right: 0.0)
        collectionView?.delegate = self
    }
}

extension FoodPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemsPerColumn: CGFloat = 4
        
        let otherInsets = collectionView.layoutMargins.top + collectionView.layoutMargins.bottom
        let cellHeight = (collectionView.frame.height / itemsPerColumn) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - otherInsets - flowLayout.minimumLineSpacing * itemsPerColumn - flowLayout.minimumInteritemSpacing * itemsPerColumn
        
        let size = CGSize(width: cellHeight, height: cellHeight)
        return size
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView?.reloadData()
    }
}
