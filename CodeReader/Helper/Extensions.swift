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
            contentHeight += subview.frame.height
        }
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}

extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
