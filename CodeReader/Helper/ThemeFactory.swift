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
       [true,   "default",          "#F0F0F0", "#397300", "#BC6060", "#1f7199", "#880000", "#888888"],
       [true,   "agate",            "#333", "#ffa", "#fcc28c", "#ade5fc", "#a2fca2", "#888"],
       [false,  "androidstudio",    "#282b2e", "#cc7832", "#629755", "#6897bb", "#ffc66d", "#808080"],
       [true,   "arduino-light",    "#FFFFFF", "#00979D", "#D35400", "#728E00", "#8A7B52", "#880000"],
       [true,   "arta",             "#222", "#6644aa", "#bb1166", "#ffcc33", "#00cc66", "#444"],
       [true,   "ascetic",          "#FFF", "#000", "#888", "#ccc", "#888", "#ccc"],
//       ["atelier-cave-dark",    "#19171c", "#955ae7", "#576ddb", "#2a9292", "#aa573c", "#be4678"],
//       ["atelier-cave-light",   "#efecf4", "#955ae7", "#576ddb", "#2a9292", "#aa573c", "#be4678"],
//       ["atelier-dune-dark",    "#20201d", "#b854d4", "#6684e1", "#60ac39", "#b65611", "#d73737"],
//       ["atelier-dune-light",   "#fefbec", "#b854d4", "#6684e1", "#60ac39", "#b65611", "#d73737"],
//       ["atelier-estuary-dark", "#22221b", "#5f9182", "#36a166", "#7d9726", "#ae7313", "#ba6236"],
//       ["atelier-estuary-light","#fef3ec", "#5f9182", "#36a166", "#7d9726", "#ae7313", "#ba6236"],
//       ["atelier-forest-dark",  "#1b1918", "#6666ea", "#407ee7", "#7b9726", "#df5320", "#f22c40"],
//       ["atelier-forest-light", "#f1efee", "#6666ea", "#407ee7", "#7b9726", "#df5320", "#f22c40"],
//       ["atelier-heath-dark",   "#1b181b", "#7b59c0", "#516aec", "#918b3b", "#a65926", "#ca402b"],
//       ["atelier-heath-light",  "#f7f3f7", "#7b59c0", "#516aec", "#918b3b", "#a65926", "#ca402b"],
//       ["atelier-lakeside-dark",    "#161b1d", "#6b6bb8", "#257fad", "#568c3b", "#935c25", "#d22d72"],
//       ["atelier-lakeside-light",   "#ebf8ff", "#6b6bb8", "#257fad", "#568c3b", "#935c25", "#d22d72"],
//       ["atelier-plateau-dark",     "#1b1818", "#8464c4", "#7272ca", "#4b8b8b", "#b45a3c", "#ca4949"],
//       ["atelier-plateau-light",    "#f4ecec", "#8464c4", "#7272ca", "#4b8b8b", "#b45a3c", "#ca4949"],
//       ["atelier-savanna-dark",     "#171c19", "#55859b", "#478c90", "#489963", "#9f713c", "#b16139"],
//       ["atelier-savanna-light",    "#ecf4ee", "#55859b", "#478c90", "#489963", "#9f713c", "#b16139"],
//       ["atelier-seaside-dark",     "#131513", "#ad2bee", "#3d62f5", "#29a329", "#87711d", "#e6193c"],
//       ["atelier-seaside-light",    "#f4fbf4", "#ad2bee", "#3d62f5", "#29a329", "#87711d", "#e6193c"],
//       ["atelier-sulphurpool-dark", "#202746", "#6679cc", "#3d8fd1", "#ac9739", "#c76b29", "#c94922"],
//       ["atelier-sulphurpool-light","#f5f7ff", "#6679cc", "#3d8fd1", "#ac9739", "#c76b29", "#c94922"],
       [true,   "brown-paper",      "#b7a68e", "#005599", "#2c009f", "#363c69", "#802022", "#2c009f"],
       [true,   "codepen-embed",    "#222", "#8f9c6c", "#9b869b", "#ab875d", "#fff", "#777"],
       [true,   "color-brewer",     "#fff", "#3182bd", "#756bb1", "#31a354", "#88f", "#636363"],
       [true,   "darkula",          "#2b2b2b", "#cb7832", "#bababa", "#e0c46c", "#6896ba", "#7f7f7f"],
       [false,  "docco",            "#000", "#954121", "#458", "#219161", "#40a070", "#408080"],
       [false,  "dracula",          "#282a36", "#8be9fd", "#f1fa8c", "#ff79c6", "#f8f8f2", "#6272a4"],
       [false,  "far",              "#000080", "#fff", "#0ff", "#ff0", "#0f0", "#888"],
       [false,  "foundation",       "#eee", "#099", "#900", "#d14", "#336699", "#998"],
       [true,   "github-gist",      "#fff", "#a71d5d", "#795da3", "#df5000", "#0086b3", "#969896"],
       [true,   "github",           "#f8f8f8", "#333", "#d14", "#008080", "#900", "#0086b3"],
       [false,  "googlecode",       "#fff", "#008", "#606", "#080", "#066", "#660"],
       [true,   "grayscale",        "#fff", "#333", "#000", "#333", "#777", "#777"],
       [false,  "gruvbox-dark",     "#282828", "#fb4934", "#83a598", "#8f3f71", "#fabd2f", "#fe8019"],
       [false,  "gruvbox-light",    "#fbf1c7", "#fb4934", "#83a598", "#8f3f71", "#fabd2f", "#fe8019"],
       [false,  "hopscotch",        "#322931", "#c85e7c", "#1290bf", "#8fc13e", "#fd8b19", "#dd464c"],
       [true,   "hybrid",           "#1d1f21", "#81a2be", "#f0c674", "#cc6666", "#b5bd68", "#de935f"],
       [false,  "idea",             "#fff", "#000080", "#000", "#008000", "#0000ff", "#660e7a"],
       [true,   "ir-black",         "#000", "#96cbfe", "#ffffb6", "#a8ff60", "#ff73fd", "#c6c5fe"],
       [false,  "kimbie.dark",      "#221a0f", "#98676a", "#f06431", "#889b4a", "#f79a32", "#dc3958"],
       [false,  "kimbie.light",     "#fbebd4", "#98676a", "#f06431", "#889b4a", "#f79a32", "#dc3958"],
       [true,   "magula",           "#f4f4f4", "#000080", "#00e", "#050", "#800", "#777"],
       [true,   "mono-blue",        "#eaeef3", "#00193a", "#4c81c9", "#0048ab", "#00193a", "#738191"],
       [false,  "monokai-sublime",  "#23241f", "#f92672", "#a6e22e", "#e6db74", "#ae81ff", "#75715e"],
       [true,   "monokai",          "#272822", "#f92672", "#a6e22e", "#fff", "#66d9ef", "#75715e"],
       [true,   "obsidian",         "#282b2e", "#93c763", "#e0e2e4", "#ec7600", "#ffcd22", "#818e96"],
       [false,  "paraiso-dark",     "#2f1e2e", "#815ba4", "#fec418", "#48b685", "#f99b15", "#ef6155"],
       [false,  "paraiso-light",    "#e7e9db", "#815ba4", "#fec418", "#48b685", "#f99b15", "#ef6155"],
       [false,  "pojoaque",         "#181914", "#b64926", "#ffb03b", "#468966", "#b58900", "#dccf8f"],
       [true,   "purebasic",        "#FFFFDF", "#006666", "#000000", "#0080FF", "#924B72", "#00AAAA"],
//       [false,  "qtcreator_dark",   "#000000", "#ffff55", "#aaaaaa", "#ff55ff", "#ff55ff", "#55ffff"],
//       [false,  "qtcreator_light",  "#ffffff", "#808000", "#000000", "#008000", "#000080", "#008000"],
       [false,  "railscasts",       "#232323", "#c26230", "#ffc66d", "#a5c261", "#e6e1dc", "#bc9458"],
       [true,   "rainbow",          "#474949", "#cc99cc", "#b5bd68", "#8abeb7", "#f99157", "#ffcc66"],
       [true,   "school-book",      "#f6f6ae", "#005599", "#2c009f", "#3e5915", "#2c009f", "#e60415"],
//       [false,  "solarized-dark",   "#002b36", "#859900", "#268bd2", "#2aa198", "#b58900", "#586e75"],
//       [false,  "solarized-light",  "#fdf6e3", "#859900", "#268bd2", "#2aa198", "#b58900", "#93a1a1"],
       [true,   "sunburst",         "#000", "#e28964", "#89bdff", "#65b042", "#3387cc", "#aeaeae"],
       [false,  "tomorrow-night-blue",      "#002451", "#ebbbff", "#bbdaff", "#d1f1a9", "#ffc58f", "#7285b7"],
       [false,  "tomorrow-night-bright",    "#000", "#c397d8", "#7aa6da", "#b9ca4a", "#e78c45", "#969896"],
       [false,  "tomorrow-night-eighties",  "#2d2d2d", "#cc99cc", "#6699cc", "#99cc99", "#f99157", "#999999"],
       [false,  "tomorrow-night",           "#1d1f21", "#b294bb", "#81a2be", "#b5bd68", "#de935f", "#969896"],
       [false,  "tomorrow",                 "#fff", "#8959a8", "#4271ae", "#718c00", "#f5871f", "#8e908c"],
       [true,   "vs",       "#fff", "#00f", "#a31515", "#2b91af", "#f00", "#008000"],
       [false,  "xcode",    "#ffffff", "#aa0d91", "#660", "#c41a16", "#1c00cf", "#006a00"],
       [false,  "xt256",    "#000", "#fff000", "#00ffff", "#008000", "#00ff00", "#969896"],
       [true,   "zenburn",  "#3f3f3f", "#e3ceab", "#efef8f", "#cc9393", "#8cd0d3", "#7f9f7f"],
    ]
    static func themes() -> [Theme] {
        var themes = [Theme]()
        for item in data {
            let theme = Theme(name: item[1] as! String)
            theme.isPurchased = item[0] as! Bool
            for i in 2..<item.count {
                theme.colors.append(UIColor(rgba: item[i] as! String))
            }
            themes.append(theme)
        }
        return themes
    }
}
