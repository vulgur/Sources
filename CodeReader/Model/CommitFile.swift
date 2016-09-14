//
//  CommitFile.swift
//  CodeReader
//
//  Created by vulgur on 16/9/2.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommitFile: Mappable {
    
    var sha: String?
    var filename: String?
    var status: String?
    var additions: Int?
    var deletions: Int?
    var chagnes: Int?
    var blogURLString: String?
    var contentsURLString: String?
    var rawURLString: String?
    var patch: String?
    
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(_ map: Map) {
        // TODO: map properties
    }
}
