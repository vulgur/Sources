//
//  CommitCell.swift
//  CodeReader
//
//  Created by vulgur on 16/9/3.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var shaLabel: UILabel!
    @IBOutlet var committerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
