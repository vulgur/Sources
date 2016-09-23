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
import Bond

class SearchRepoViewModel {
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }
    
    var searchResults = MutableObservableArray<Repo>([Repo]())
    var searchInProgress = Observable<Bool>(false)
    var searchKeyword = Observable<String>("")
    
//    var keyword = ""
    var currentPage = 1
    var totalPage = 0
    var sortType: SortType = .Best
    
    func searchRepos(completion: @escaping () -> (), errorHandler: ((String) -> ())? = nil) {
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : sortType.rawValue,
        ]
        searchInProgress.value = true
        
        // Fetch Request
        Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
            .responseObject { (response: DataResponse<SearchRepoResponse>) in
                if let searchResult = response.result.value {
                    searchResult.items?.forEach({ (item) in
                        self.searchResults.append(item)
                    })
                    
                    completion()
                }
            EZLoadingActivity.hide()
        }
//            .responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    if let statusCode = response.response?.statusCode{
//                        switch statusCode{
//                        case 200..<299:
//                            if let value = response.result.value as? [String: Any] {
//                                if let items = value["items"], let results = Mapper<Repo>().mapArray(JSONArray: items as! [[String : Any]]) {
//                                    self.searchResults.removeAll()
//                                    self.searchResults.insert(contentsOf: results, at: 0)
//                                    completion()
//                                }
//                            }
//                        default:
//                            if let message = response.result.value!["message"], let errorHandler = errorHandler {
//                                errorHandler(message as! String)
//                            }
//                        }
//                        
//                    }
//                case .failure(let error):
//                    print(error)
//                    if let errorHandler = errorHandler {
//                        errorHandler(error.localizedDescription)
//                    }
//                }
//                self.searchInProgress.value = false
//            }
    }
    
    func loadMore(completion: @escaping ()->(), errorHandler: ((String) -> ())? = nil) {
        
        currentPage += 1
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : sortType.rawValue,
            "page" : "\(currentPage)"
        ]
        // Fetch Request
        Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
            .responseObject { (response: DataResponse<SearchRepoResponse>) in
                log.info(response.result.value)
        }
//            .responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    if let statusCode = response.response?.statusCode{
//                        switch statusCode{
//                        case 200..<299:
//                            if let items = response.result.value!["items"], let results = Mapper<Repo>().mapArray(items) {
//                                    self.repos.append(contentsOf: results)
//                                    completion()
//                            }
//                        default:
//                            self.currentPage -= 1
//                            if let message = response.result.value!["message"], let errorHandler = errorHandler {
//                                errorHandler(message as! String)
//                            }
//                        }
//                        
//                    }
//                case .failure(let error):
//                    self.currentPage -= 1
//                    if let errorHandler = errorHandler {
//                        errorHandler(error.localizedDescription)
//                    }
//                }
//            }
    }
}
