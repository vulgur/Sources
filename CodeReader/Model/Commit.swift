//
//  Commit.swift
//  CodeReader
//
//  Created by vulgur on 16/9/1.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

// "parents" item in JSON
struct ParentCommit: Mappable {
    var URLString: String?
    var htmlURLString: String?
    var sha: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        URLString       <- map["url"]
        htmlURLString   <- map["html_url"]
        sha             <- map["sha"]
    }
}


struct Commit: Mappable {
    var sha: String?
    var committerName: String?
//    var author: User?
    var committer: User?
    var URLString: String?
    var htmlURLString: String?
//    var commentsURLString: String?
    var parents = [ParentCommit]()
    var message: String?
//    var comment_count: Int?
    var files = [CommitFile]()
    var date: NSDate?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sha                 <- map["sha"]
        URLString           <- map["url"]
        htmlURLString       <- map["html_url"]
//        author              <- map["author"]
        committer           <- map["committer"]
        committerName       <- map["commit"]["committer"]["name"]
        date                <- map["commit"]["committer"]["date"]
//        comment_count       <- map["commit"]["comment_count"]
        message             <- map["commit"]["message"]
//        commentsURLString   <- map["comments_url"]
        parents             <- map["parents"]
        files               <- map["files"]
    }
}
