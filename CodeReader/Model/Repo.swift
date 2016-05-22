//
//  Repo.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import ObjectMapper

class Repo: Mappable {
    
    var repoId: String?
    var name: String?
    var fullName: String?
    var owner: Owner?
    var description: String?
    var size: Int?
    var starsCount: Int?
    var watchersCount: Int?
    var language: String?
    var forksCount: Int?
    var createdDate: String?
    var pushedDate: String?
    
    required init?(_ map: Map) {
    
    }
    
    // Mappable
    func mapping(map: Map) {
        repoId          <- map["id"]
        name            <- map["name"]
        fullName        <- map["full_name"]
        owner           <- map["owner"]
        description     <- map["description"]
        size            <- map["size"]
        starsCount      <- map["stargazers_count"]
        language        <- map["language"]
        forksCount      <- map["forks"]
        createdDate     <- map["created_at"]
        pushedDate      <- map["pushed_at"]
    }
    
}
