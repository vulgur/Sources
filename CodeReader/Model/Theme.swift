//
//  Theme.swift
//  CodeReader
//
//  Created by vulgur on 16/6/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class Theme {
    var name: String!
    var colors = [UIColor?]()
    required init(name: String) {
        self.name = name
    }
}
