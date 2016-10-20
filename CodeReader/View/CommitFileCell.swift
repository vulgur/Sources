//
//  CommitFileCell.swift
//  CodeReader
//
//  Created by vulgur on 2016/10/19.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class CommitFileCell: UITableViewCell {
    
    enum FileChangeType {
        case Addition
        case Deletion
        case Default
        
        func backgroundColor() -> UIColor {
            switch self {
            case .Addition:
                return UIColor("#55A532")
            case .Deletion:
                return UIColor("#BD2D00")
            default:
                return UIColor("#DDDDDD")
            }
        }
    }

    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var filenameLabel: UILabel!
    @IBOutlet var deletionsLabel: InsetsLabel!
    @IBOutlet var additionsLabel: InsetsLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.additionsLabel.layer.cornerRadius = 3
        self.deletionsLabel.layer.cornerRadius = 3
        
        self.additionsLabel.layer.masksToBounds = true
        self.additionsLabel.insets = UIEdgeInsetsMake(0, 5, 0, 5)
        self.deletionsLabel.layer.masksToBounds = true
        self.deletionsLabel.insets = UIEdgeInsetsMake(0, 5, 0, 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
