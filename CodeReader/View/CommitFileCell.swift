//
//  CommitFileCell.swift
//  CodeReader
//
//  Created by vulgur on 2016/10/19.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class CommitFileCell: UITableViewCell {

    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var filenameLabel: UILabel!
    @IBOutlet var deletionsLabel: UILabel!
    @IBOutlet var additionsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
