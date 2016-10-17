//
//  BranchListViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/9/6.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift
import RxCocoa

class BranchListViewModel {
    
    var branches = Variable<[Branch]>([])
    var ownerName: String!
    var repoName: String!
    let disposeBag = DisposeBag()
    
    init(ownerName: String, repoName: String) {
        
        self.ownerName = ownerName
        self.repoName = repoName
        
        loadBranches().subscribe(onNext: { (branches) in
            self.branches.value = branches
            }, onError: { error in
                log.error("Error in loading branches: \(error)")
            })
        .addDisposableTo(disposeBag)
    }
    
    
    func loadLatestCommit(urlString: String) -> Observable<CommitItem> {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(urlString).responseObject { (response: DataResponse<CommitItem>) in
                if let commit = response.result.value {
                    observer.onNext(commit)
                    observer.onCompleted()
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            return Disposables.create {
                log.info("dipose request: \(request)")
            }
        })
    }
    
    func loadBranches() -> Observable<[Branch]> {
        let url = "https://api.github.com/repos/\(ownerName!)/\(repoName!)/branches"
        
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(url)
                .responseArray(completionHandler: { (response: DataResponse<[Branch]>) in
                    if let branches = response.result.value {
                        observer.onNext(branches)
                        observer.onCompleted()
                    } else if let error = response.result.error{
                        observer.onError(error)
                    }
                    
                })
            return Disposables.create {
                log.info("dispose request: \(request)")
            }
        })
    }
}
