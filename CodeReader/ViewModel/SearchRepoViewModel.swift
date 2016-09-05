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
import Bond

class SearchRepoViewModel {
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }
    
    var repos = [Repo]()
    var searchResults = ObservableArray<Repo>()
    var searchInProgress = Observable<Bool>(false)
    var searchKeyword = Observable<String>("")
    
//    var keyword = ""
    var currentPage = 1
    var totalPage = 0
    var sortType: SortType = .Best
    
    func searchRepos(completion completion: () -> (), errorHandler: ((String) -> ())? = nil) {
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : sortType.rawValue,
        ]
        searchInProgress.value = true
        
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode{
                        switch statusCode{
                        case 200..<299:
                            if let items = response.result.value!["items"], results = Mapper<Repo>().mapArray(items) {
//                                    self.repos = results
                                    self.searchResults.removeAll()
                                    self.searchResults.insertContentsOf(results, atIndex: 0)
                                    completion()
                            }
                        default:
                            if let message = response.result.value!["message"], errorHandler = errorHandler {
                                errorHandler(message as! String)
                            }
                        }
                        
                    }
                case .Failure(let error):
                    print(error)
                    if let errorHandler = errorHandler {
                        errorHandler(error.localizedDescription)
                    }
                }
                self.searchInProgress.value = false
            }
    }
    
    func loadMore(completion completion: ()->(), errorHandler: ((String) -> ())? = nil) {
        
        currentPage += 1
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : sortType.rawValue,
            "page" : "\(currentPage)"
        ]
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode{
                        switch statusCode{
                        case 200..<299:
                            if let items = response.result.value!["items"], results = Mapper<Repo>().mapArray(items) {
                                    self.repos.appendContentsOf(results)
                                    completion()
                            }
                        default:
                            self.currentPage -= 1
                            if let message = response.result.value!["message"], errorHandler = errorHandler {
                                errorHandler(message as! String)
                            }
                        }
                        
                    }
                case .Failure(let error):
                    self.currentPage -= 1
                    if let errorHandler = errorHandler {
                        errorHandler(error.localizedDescription)
                    }
                }
            }
    }
}