//
//  Extensions.swift
//  CodeReader
//
//  Created by vulgur on 16/5/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadDataWithAutoSizingCells() {
        self.reloadData()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
        self.reloadData()
    }
}

extension UIScrollView {
    func resizeContentSize() {
        let contentWidth = self.frame.width
        var contentHeight: CGFloat = 0
        for subview in subviews {
            contentHeight += CGRectGetHeight(subview.frame)
        }
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
}
