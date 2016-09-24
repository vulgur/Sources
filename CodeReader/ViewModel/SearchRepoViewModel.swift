//
//  SearchRepoViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/5/14.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift

class SearchRepoViewModel {
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }
    
    
//    var searchResults = Observable<[Repo]>()
//    var searchInProgress = Observable<Bool>()
//    var searchKeyword = Observable<String>()
    
//    var keyword = ""
    var currentPage = 1
    var totalPage = 0
    var sortType: SortType = .Best
    
    func searchRepos(keyword: String) -> Observable<[Repo]> {
        return Observable.just([])
    }
    
//    func searchRepos(completion: @escaping () -> (), errorHandler: ((String) -> ())? = nil) {
//        let urlParams = [
//            "q": searchKeyword.value,
//            "sort" : sortType.rawValue,
//        ]
//        searchInProgress.value = true
//        
//        // Fetch Request
//        Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
//            .responseObject { (response: DataResponse<SearchRepoResponse>) in
//                if let searchResult = response.result.value {
//                    searchResult.items?.forEach({ (item) in
//                        self.searchResults.append(item)
//                    })
//                    
//                    completion()
//                }
//            EZLoadingActivity.hide()
//        }
//
//    }
//    
//    func loadMore(completion: @escaping ()->(), errorHandler: ((String) -> ())? = nil) {
//        
//        currentPage += 1
//        let urlParams = [
//            "q": searchKeyword.value,
//            "sort" : sortType.rawValue,
//            "page" : "\(currentPage)"
//        ]
//        // Fetch Request
//        Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
//            .responseObject { (response: DataResponse<SearchRepoResponse>) in
//                log.info(response.result.value)
//        }
//
//    }
}
