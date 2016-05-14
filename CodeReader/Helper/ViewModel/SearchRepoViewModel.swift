//
//  SearchRepoViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/5/14.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class SearchRepoViewModel {
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }
    
    
    var repos = [Repo]()
    var keyword = ""
    var currentPage = 1
    var totalPage = 0
    var sortType: SortType = .Best
    
    func searchRepos(completion: () -> ()) {
        let urlParams = [
            "q": keyword,
            "sort" : sortType.rawValue,
            "page" : "\(currentPage)"
        ]
        
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseJSON { (response) in
                if let items = response.result.value!["items"], results = Mapper<Repo>().mapArray(items) {
                        self.repos = results
                        completion()
                }
            }

    }
    
    func loadMore(completion: () -> ()) {
        
    }
    
}