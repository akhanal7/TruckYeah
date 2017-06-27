//
//  TruckCell.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 11/11/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit

class TruckCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var truckImage: UIImageView!
    @IBOutlet var paddingView: UIView!
    var truckID: NSNumber?

 
    @IBAction func buttonClicked(_ sender: UIButton) {
        print("button clicked")     
    }
    
    
}
