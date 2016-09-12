//
//  Branch.swift
//  CodeReader
//
//  Created by vulgur on 16/9/5.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

struct LatestCommit: Mappable {
    var sha: String?
    var URLString: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sha        <- map["sha"]
        URLString  <- map["url"]
    }
}

struct Branch: Mappable {
    
    var name: String?
    var lastestCommit: LatestCommit?
    var lastestUpdateDate: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name            <- map["name"]
        lastestCommit   <- map["commit"]
    }
}
