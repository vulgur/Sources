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
    let apiURLString: String?
    
    var page = 1
    
    init(apiURLString: String) {
        self.apiURLString = apiURLString
        self.page = 1
    }
    
    func loadCommitList() -> Observable<[CommitItem]> {
        return Observable.create({ (observer) -> Disposable in
            guard let url = self.apiURLString else {
                return Disposables.create {
                    log.error("wrong url")
                }
            }
            let apiURL = url + "&page=" + "\(self.page)"
            let request = Alamofire.request(apiURL)
                .responseArray(completionHandler: { (response: DataResponse<[CommitItem]>) in
                    if let items = response.result.value {
                        observer.onNext(items)
                        observer.onCompleted()
                        self.page += 1
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
