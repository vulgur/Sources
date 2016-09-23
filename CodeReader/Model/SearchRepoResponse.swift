//
//  SearchRepoResponse.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchRepoResponse: Mappable {
    var totalCount: Int?
    var items: [Repo]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalCount  <- map["total_count"]
        items       <- map["items"]
    }
}
