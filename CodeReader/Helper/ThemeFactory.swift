//
//  ThemeFactory.swift
//  CodeReader
//
//  Created by vulgur on 16/6/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import HEXColor

class ThemeFactory {
    static let data = [
       ["default", "#F0F0F0", "#397300", "#BC6060", "#1f7199", "#880000", "#888888"],
       ["agate", "#333", "#ffa", "#fcc28c", "#ade5fc", "#a2fca2", "#888"],
       ["androidstudio", "#282b2e", "#cc7832", "#629755", "#6897bb", "#ffc66d", "#808080"],
    ]
    static func themes() -> [Theme] {
        var themes = [Theme]()
        for item in data {
            let theme = Theme(name: item[0])
            for i in 1..<item.count {
                theme.colors.append(UIColor(rgba: item[i]))
            }
            themes.append(theme)
        }
        return themes
    }
}
