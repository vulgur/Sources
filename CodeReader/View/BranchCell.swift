//
//  BranchCell.swift
//  CodeReader
//
//  Created by vulgur on 16/9/12.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class BranchCell: UITableViewCell {

    @IBOutlet var branchLabel: InsetsLabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var updateInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

