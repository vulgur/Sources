//
//  Recent.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation

struct Recent {
    var file: RepoFile
    var ownerName: String
    var repoName: String
    
    init(file: RepoFile, ownerName: String, repoName: String) {
        self.file = file
        self.ownerName = ownerName
        self.repoName = repoName
    }
}