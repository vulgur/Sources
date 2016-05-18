//
//  Owner.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import ObjectMapper

class Owner: Mappable {
    var name: String?
    var ownerId: String?
    var avatarURLString: String?
    
    required init?(_ map: Map) {
        
    }
   
    init() {
        
    }
    // Mappable
    func mapping(map: Map) {
        name            <- map["login"]
        ownerId         <- map["id"]
        avatarURLString <- map["avatar_url"]
    }
    
}
