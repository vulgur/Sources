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
    
    var searchInProgress = Variable<Bool>(false)
    var sortType = Variable<SortType>(.Best)
    
    // MARK: Input
    let cellDidSelect = PublishSubject<IndexPath>()
    let segmentDidSelect = PublishSubject<Int>()
    var searchKeyword = PublishSubject<String>()
    
    // MARK: Output
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    var repos: [Repo]
    

    var currentPage = 1
    var totalPage = 0
//    var sortType: SortType = .Best
    
    init() {
        
        self.repos = [Repo]()
        self.cellDidSelect
            .subscribe(onNext: { (indexPath) in
                print("Selected: \(indexPath.section)-\(indexPath.row)")
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func searchRepos(keyword: String) -> Observable<[Repo]> {
        let escapedKeyword = keyword.URLEscaped
        let urlParams = [
            "q": escapedKeyword,
            "sort" : self.sortType.value.rawValue,
            ]
        return Observable.create({ (observer) -> Disposable in

            self.searchInProgress.value = true
            let request = Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
                        .responseObject { (response: DataResponse<SearchRepoResponse>) in
                            if let searchResult = response.result.value {
                                self.repos.append(contentsOf: searchResult.items!)
                                observer.onNext(self.repos)
                                observer.onCompleted()
                            } else if let error = response.result.error {
                                observer.onError(error)
                            }
            }
            return Disposables.create {
                log.info("dispose request:\(request)")
            }
        })
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
