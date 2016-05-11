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
