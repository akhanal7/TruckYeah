//
//  MenuCell.swift
//  TruckYeah
//
//  Created by Coulter, Alexis B on 2/18/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

class FoodMenuCell: UICollectionViewCell {
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemPrice: UILabel!
    
//    func update(with image: UIImage?) {
//        if let imageToDisplay = image {
//            spinner.stopAnimating()
//            imageView.image = imageToDisplay
//        } else {
//            spinner.startAnimating()
//            imageView.image = nil
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // update(with:nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //update(with: nil)
    }
    
}
