//
//  MenuOptionCell.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 12/26/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {
    
    @IBOutlet var customImage: UIImageView!
    @IBOutlet var customText: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.customText.textColor = UIColor.white
            self.customText?.textColor = UIColor.white
            let oldGold = UIColor(red: 206/256.0, green: 180/256.0, blue: 70/256.0, alpha: 1.0)
            contentView.backgroundColor = oldGold
            
            let selectedView = UIView()
            selectedView.backgroundColor = oldGold
            selectedBackgroundView = selectedView
        } else {
            self.customText.textColor = UIColor.black
            self.contentView.backgroundColor = UIColor.white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            self.customText?.textColor = UIColor.white
            let oldGold = UIColor(red: 206/256.0, green: 180/256.0, blue: 70/256.0, alpha: 1.0)
            contentView.backgroundColor = oldGold
            
            let selectedView = UIView()
            selectedView.backgroundColor = oldGold
            selectedBackgroundView = selectedView
            
        } else {
            self.contentView.backgroundColor = UIColor.white
            self.customText?.textColor = UIColor.black
        }
    }
}
