//
//  ThemeCell.swift
//  CodeReader
//
//  Created by vulgur on 16/6/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {

    @IBOutlet var lockImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var colorView1: UIView!
    @IBOutlet var colorView2: UIView!
    @IBOutlet var colorView3: UIView!
    @IBOutlet var colorView4: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
