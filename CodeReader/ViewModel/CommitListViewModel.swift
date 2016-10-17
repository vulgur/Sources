//
//  CommitListViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/9/5.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

class CommitListViewModel {
    
    var commits = Variable<[CommitItem]>([])
    var isLoading = Variable<Bool>(false)
    let apiURLString: String?
    
    var nextPageUrl: String = ""
    
    init(apiURLString: String) {
        self.apiURLString = apiURLString
    }
    
    func loadCommitList() -> Observable<[CommitItem]> {
        return Observable.create({ (observer) -> Disposable in
            guard let url = self.apiURLString else {
                return Disposables.create {
                    log.error("wrong url")
                }
            }
            let request = Alamofire.request(url)
                .responseArray(completionHandler: { (response: DataResponse<[CommitItem]>) in
                    if let items = response.result.value {
                        observer.onNext(items)
                        observer.onCompleted()
                    } else if let error = response.result.error {
                        observer.onError(error)
                    }
                })
            return Disposables.create {
                log.info("dispose request: \(request)")
            }
        })
    }
}
