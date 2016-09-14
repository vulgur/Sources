//
//  User.swift
//  CodeReader
//
//  Created by vulgur on 16/9/2.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

/**
    User object for search result and bio page
*/
struct User: Mappable {
    
    /** search info **/
    var loginName: String?
    var userId: String?
    var avatarURLString: String?
    var URLString: String?
    var reposURLString: String?
    
    /** bio info **/
    var username: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var bio: String?
    var publicReposCount: Int?
    var followersCount: Int?
    var followingCount: Int?
    var joinAtDate: Date?
    
    
    init() {
        
    }
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(_ map: Map) {
        loginName               <- map["login"]
        userId                  <- map["id"]
        avatarURLString         <- map["avatar_url"]
        URLString               <- map["url"]
        reposURLString          <- map["repos_url"]
        
        username                <- map["name"]
        company                 <- map["company"]
        blog                    <- map["blog"]
        location                <- map["location"]
        email                   <- map["email"]
        bio                     <- map["bio"]
        publicReposCount        <- map["public_repos"]
        followersCount          <- map["followers"]
        followingCount          <- map["following"]
        joinAtDate              <- map["created_at"]
    }
}
