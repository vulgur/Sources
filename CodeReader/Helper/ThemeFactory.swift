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
       ["default",          "#F0F0F0", "#397300", "#BC6060", "#1f7199", "#880000", "#888888"],
       ["agate",            "#333", "#ffa", "#fcc28c", "#ade5fc", "#a2fca2", "#888"],
       ["androidstudio",    "#282b2e", "#cc7832", "#629755", "#6897bb", "#ffc66d", "#808080"],
       ["arduino-light",    "#FFFFFF", "#00979D", "#D35400", "#728E00", "#8A7B52", "#880000"],
       ["arta",             "#222", "#6644aa", "#bb1166", "#ffcc33", "#00cc66", "#444"],
       ["ascetic",          "#FFF", "#000", "#888", "#ccc", "#888", "#ccc"],
       ["atelier-cave-dark",    "#19171c", "#955ae7", "#576ddb", "#2a9292", "#aa573c", "#be4678"],
       ["atelier-cave-light",   "#efecf4", "#955ae7", "#576ddb", "#2a9292", "#aa573c", "#be4678"],
       ["atelier-dune-dark",    "#20201d", "#b854d4", "#6684e1", "#60ac39", "#b65611", "#d73737"],
       ["atelier-dune-light",   "#fefbec", "#b854d4", "#6684e1", "#60ac39", "#b65611", "#d73737"],
       ["atelier-estuary-dark", "#22221b", "#5f9182", "#36a166", "#7d9726", "#ae7313", "#ba6236"],
       ["atelier-estuary-light","#fef3ec", "#5f9182", "#36a166", "#7d9726", "#ae7313", "#ba6236"],
       ["atelier-forest-dark",  "#1b1918", "#6666ea", "#407ee7", "#7b9726", "#df5320", "#f22c40"],
       ["atelier-forest-light", "#f1efee", "#6666ea", "#407ee7", "#7b9726", "#df5320", "#f22c40"],
       ["atelier-heath-dark",   "#1b181b", "#7b59c0", "#516aec", "#918b3b", "#a65926", "#ca402b"],
       ["atelier-heath-light",  "#f7f3f7", "#7b59c0", "#516aec", "#918b3b", "#a65926", "#ca402b"],
       ["atelier-lakeside-dark",    "#161b1d", "#6b6bb8", "#257fad", "#568c3b", "#935c25", "#d22d72"],
       ["atelier-lakeside-light",   "#ebf8ff", "#6b6bb8", "#257fad", "#568c3b", "#935c25", "#d22d72"],
       ["atelier-plateau-dark",     "#1b1818", "#8464c4", "#7272ca", "#4b8b8b", "#b45a3c", "#ca4949"],
       ["atelier-plateau-light",    "#f4ecec", "#8464c4", "#7272ca", "#4b8b8b", "#b45a3c", "#ca4949"],
       ["atelier-savanna-dark",     "#171c19", "#55859b", "#478c90", "#489963", "#9f713c", "#b16139"],
       ["atelier-savanna-light",    "#ecf4ee", "#55859b", "#478c90", "#489963", "#9f713c", "#b16139"],
       ["atelier-seaside-dark",     "#131513", "#ad2bee", "#3d62f5", "#29a329", "#87711d", "#e6193c"],
       ["atelier-seaside-light",    "#f4fbf4", "#ad2bee", "#3d62f5", "#29a329", "#87711d", "#e6193c"],
       ["atelier-sulphurpool-dark", "#202746", "#6679cc", "#3d8fd1", "#ac9739", "#c76b29", "#c94922"],
       ["atelier-sulphurpool-light","#f5f7ff", "#6679cc", "#3d8fd1", "#ac9739", "#c76b29", "#c94922"],
       ["brown-paper",      "#b7a68e", "#005599", "#2c009f", "#363c69", "#802022", "#2c009f"],
       ["codepen-embed",    "#222", "#8f9c6c", "#9b869b", "#ab875d", "#fff", "#777"],
       ["color-brewer",     "#fff", "#3182bd", "#756bb1", "#31a354", "#88f", "#636363"],
       ["darkula",          "#2b2b2b", "#cb7832", "#bababa", "#e0c46c", "#6896ba", "#7f7f7f"],
       ["docco",            "#000", "#954121", "#458", "#219161", "#40a070", "#408080"],
       ["dracula",          "#282a36", "#8be9fd", "#f1fa8c", "#ff79c6", "#f8f8f2", "#6272a4"],
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
