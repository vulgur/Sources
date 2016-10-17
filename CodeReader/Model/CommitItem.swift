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
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        URLString       <- map["url"]
        htmlURLString   <- map["html_url"]
        sha             <- map["sha"]
    }
}

struct CommitUser: Mappable {
    
    var name: String?
    var email: String?
    var dateString: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name        <- map["name"]
        email       <- map["email"]
        dateString  <- map["date"]
    }
}

struct CommitInfo: Mappable {
    var author: CommitUser?
    var committer: CommitUser?
    var message: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        author      <- map["author"]
        committer   <- map["committer"]
        message     <- map["message"]
    }
}


struct CommitItem: Mappable {
    var sha: String?
//    var author: User?
    var committer: User?
    var URLString: String?
    var htmlURLString: String?
    var parents = [ParentCommit]()
    var commitInfo: CommitInfo?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sha                 <- map["sha"]
        URLString           <- map["url"]
        htmlURLString       <- map["html_url"]
        commitInfo          <- map["commit"]
        committer           <- map["committer"]
        parents             <- map["parents"]

    }
}
