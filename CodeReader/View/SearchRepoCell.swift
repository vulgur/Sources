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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ownerAvatarImageView.layer.masksToBounds = true
        ownerAvatarImageView.layer.cornerRadius = 20
//        ownerAvatarImageView.layer.borderColor = UIColor.blackColor().CGColor
//        ownerAvatarImageView.layer.borderWidth = 1
        repoNameLabel.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
