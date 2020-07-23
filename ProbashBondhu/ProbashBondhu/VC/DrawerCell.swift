//
//  DrawerCell.swift
//  slideOutTest
//
//  Created by PRI on 3/26/19.
//  Copyright © 2019 PRI. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {

    @IBOutlet weak var lblController: UILabel!
    @IBOutlet weak var imgController: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        countLabel.layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
