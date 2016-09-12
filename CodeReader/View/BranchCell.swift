//
//  BranchCell.swift
//  CodeReader
//
//  Created by vulgur on 16/9/12.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class BranchCell: UITableViewCell {

    @IBOutlet var branchLabel: BranchLabel!
    @IBOutlet var updateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

@IBDesignable class BranchLabel: UILabel {
    @IBInspectable var topInsets: CGFloat = 0.0
    @IBInspectable var bottomInsets: CGFloat = 0.0
    @IBInspectable var leftInsets: CGFloat = 5.0
    @IBInspectable var rightInsets: CGFloat = 5.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsetsMake(topInsets, leftInsets, bottomInsets, rightInsets)
        }
        set {
            topInsets = newValue.top
            bottomInsets = newValue.bottom
            leftInsets = newValue.left
            rightInsets = newValue.right
        }
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insects = UIEdgeInsets.init(top:topInsets, left: leftInsets, bottom: bottomInsets, right: rightInsets)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insects))
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.width += leftInsets + rightInsets
        newSize.height += topInsets + bottomInsets
        return newSize
    }
    
    override func intrinsicContentSize() -> CGSize {
        var contentSize = super.intrinsicContentSize()
        contentSize.width += leftInsets + rightInsets
        contentSize.height += topInsets + bottomInsets
        return contentSize
    }
}
