//
//  ThemeViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/6/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class ThemeViewModel {
    var themes = [Theme]()
    init() {
       themes = ThemeFactory.themes()
    }
//    let name = Observable("")
//    let keywordColor = Observable(UIColor.blackColor()) // colors[0]
//    let backgroundColor = Observable(UIColor.whiteColor()) // colors[1]
//    let color1 = Observable(UIColor.whiteColor()) // colors[2]
//    let color2 = Observable(UIColor.whiteColor()) // colors[3]
//    let color3 = Observable(UIColor.whiteColor()) // colors[4]
//    let color4 = Observable(UIColor.whiteColor()) // colors[5]
//    
//    init(theme: Theme) {
//        name.value = theme.name
//        keywordColor.value = theme.colors[0] ?? UIColor.blackColor()
//        backgroundColor.value = theme.colors[1] ?? UIColor.blackColor()
//        color1.value = theme.colors[2] ?? UIColor.blackColor()
//        color2.value = theme.colors[3] ?? UIColor.blackColor()
//        color3.value = theme.colors[4] ?? UIColor.blackColor()
//        color4.value = theme.colors[5] ?? UIColor.blackColor()
//    }
}
