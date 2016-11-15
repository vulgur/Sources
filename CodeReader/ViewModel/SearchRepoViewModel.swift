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
import RxCocoa
import Crashlytics

class SearchRepoViewModel {
    enum SearchError: Error {
        case Error404
    }
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }
    
    var searchInProgress = Variable<Bool>(false)
    var sortType = Variable<SortType>(.Best)
    var searchKeyword = Variable<String>("")
    var repos = Variable<[Repo]>([])
    
    // MARK: Input
//    let cellDidSelect = PublishSubject<IndexPath>()
    let segmentDidSelect = PublishSubject<Int>()

    
    // MARK: Output
    var searchResults: Driver<[Repo]>!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    

    var currentPage = 1
    var totalPage = 0

    
    init() {
        
        _ = self.sortType.asObservable().subscribe(onNext: { sortType in
            log.info("SortType changes to \(sortType)")
            _ = self.searchRepos()
        })

        self.segmentDidSelect
            .map({ (index) -> SortType in
                log.info("SegmentedControl change to \(index)")
                switch index {
                case 0: return .Best
                case 1: return .Stars
                case 2: return .Forks
                case 3: return .Updated
                default: return .Best
                }
            })
            .filter({ (type) -> Bool in
              
                if type == .Best && self.searchKeyword.value.isEmpty {
                    return false
                } else {
                    return true
                }
            })
            .subscribe(onNext: { (type) in
                log.info("Sorte Type: \(type)")
                self.sortType.value = type
                _ = self.searchRepos().subscribe(onNext: { (results) in
                    self.repos.value = results
                })
                
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func searchRepos() -> Observable<[Repo]> {
        
        searchKeyword.value = searchKeyword.value.URLEscaped
        guard !searchKeyword.value.isEmpty else {
            return Observable.empty()
        }
        
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : self.sortType.value.rawValue,
            ]
        return Observable.create({ (observer) -> Disposable in
            

            self.searchInProgress.value = true
            let request = Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
                        .responseObject { (response: DataResponse<SearchRepoResponse>) in
                            guard let statusCode = response.response?.statusCode,
                                statusCode < 300 else {
                                observer.onError(SearchError.Error404)
                                log.error(response.result.description)
                                return
                            }
                
                            if let searchResult = response.result.value, let items = searchResult.items {
                                observer.onNext(items)
                                observer.onCompleted()
                                Answers.logSearch(withQuery: self.searchKeyword.value, customAttributes: nil)
                            } else if let error = response.result.error {
                                log.error(error)
                                observer.onError(error)
                            }
                            self.searchInProgress.value = false
                        
                        }
            return Disposables.create {
                log.info("dispose request:\(request)")
            }
        })
    }
    
    func loadMore() -> Observable<[Repo]> {
        
        currentPage += 1
        let urlParams = [
            "q": searchKeyword.value,
            "sort" : sortType.value.rawValue,
            "page" : "\(currentPage)"
        ]
        // Fetch Request
        return Observable.create({ (observer) -> Disposable in
            self.searchInProgress.value = true
            let request = Alamofire.request("https://api.github.com/search/repositories", parameters: urlParams)
                .responseObject { (response: DataResponse<SearchRepoResponse>) in
                    
                    if let searchResult = response.result.value,
                        let items = searchResult.items {
                        observer.onNext(items)
                        observer.onCompleted()
                    } else if let error = response.result.error {
                        observer.onError(error)
                    }
                    self.searchInProgress.value = false
            }
            return Disposables.create {
                log.info("dispose request: \(request)")
            }
        })
        
    }
}
