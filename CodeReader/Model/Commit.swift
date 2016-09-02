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


// short info for "author" and "committer"
struct CommitUser: Mappable {
    var name: String?
    var email: String?
    var date: NSDate?
    var avatarURLString: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name    <- map["name"]
        email   <- map["email"]
        date    <- map["date"]
    }
}

struct CommitListItem: Mappable {
    
    var URLString: String?
    var htmlURLString: String?
    var commentsURLString: String?
    var sha: String?
    var author: CommitUser?
    var committer: CommitUser?
    var parents = [ParentCommit]()
    var message: String?
    var comment_count: Int?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sha                 <- map["sha"]
        URLString           <- map["url"]
        htmlURLString       <- map["html_url"]
        author              <- map["commit"]["author"]
        committer           <- map["commit"]["committer"]
        comment_count       <- map["commit"]["comment_count"]
        message             <- map["commit"]["message"]
        commentsURLString   <- map["comments_url"]
        parents             <- map["parents"]
    }
}

/*
struct Commit: Mappable {
    var sha: String?
    var author: CommitUser?
    var committer: CommitUser?
    var URLString: String?
    var htmlURLString: String?
    var commentsURLString: String?
    var parents = [ParentCommit]()
    var message: String?
    var comment_count: Int?
    var files = [CommitFile]()
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        // TODO: map the properties
        sha                 <- map["sha"]
        author              <- map["author"]
        committer           <- map["committer"]
        URLString           <- map["url"]
        htmlURLString       <- map["html_url"]
        commentsURLString   <- map["comments_url"]
        comment_count       <- map["commit"]["comment_count"]
        message             <- map["commit"]["message"]
        files               <- map["files"]
    }
}
*/
