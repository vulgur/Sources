//
//  CommitFile.swift
//  CodeReader
//
//  Created by vulgur on 16/9/2.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 item in one commit, reperesent for changes of a file
 **/
struct CommitFile: Mappable {
    
    var sha: String?
    var filename: String?
    var status: String?
    var additions: Int?
    var deletions: Int?
    var changes: Int?
//    var blogURLString: String?
//    var contentsURLString: String?
//    var rawURLString: String?
    var patch: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sha         <- map["sha"]
        filename    <- map["filename"]
        status      <- map["status"]
        additions   <- map["additions"]
        deletions   <- map["deletions"]
        changes     <- map["changes"]
        patch       <- map["patch"]
    }
}

/** single commit **/
struct Commit: Mappable {
    var files = [CommitFile]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        files <- map["files"]
    }
}
