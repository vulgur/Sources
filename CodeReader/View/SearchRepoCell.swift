//
//  SearchRepoCell.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class SearchRepoCell: UITableViewCell {

    @IBOutlet var ownerAvatarImageView: UIImageView!
    @IBOutlet var repoNameLabel: UILabel!
    @IBOutlet var repoDescriptionLabel: UILabel!
    @IBOutlet var repoStarsLabel: UILabel!
    @IBOutlet var repoForksLabel: UILabel!
    @IBOutlet var ownerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
