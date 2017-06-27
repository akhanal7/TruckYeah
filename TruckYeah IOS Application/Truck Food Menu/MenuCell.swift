//
//  MenuCell.swift
//  TruckYeah
//
//  Created by Coulter, Alexis B on 2/18/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemInfo: UIButton!
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print("button clicked")
    }
    
    
}
