//
//  RepoFile.swift
//  CodeReader
//
//  Created by vulgur on 16/5/27.
//  Copyright © 2016年 MAD. All rights reserved.
//

import ObjectMapper

class RepoFile: Mappable {
    var name: String?
    var type: String?
    var path: String?
    var downloadURLString: String?
    var htmlURLString: String?
    var apiURLString: String?
    
    required init?(_ map: Map) {
    
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        type                <- map["type"]
        path                <- map["path"]
        downloadURLString   <- map["download_url"]
        htmlURLString       <- map["html_url"]
        apiURLString        <- map["url"]
    }
}
