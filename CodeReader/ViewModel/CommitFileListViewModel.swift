//
//  CommitFileListViewModel.swift
//  CodeReader
//
//  Created by vulgur on 2016/11/14.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

class CommitFileListViewModel {
    
    var commitFiles = Variable<[CommitFile]>([])
    
    var apiURLString: String?
    
    init(apiURLString: String) {
        self.apiURLString = apiURLString
    }
    
    func loadCommitFileList() -> Observable<[CommitFile]> {
        return Observable.create({ (observer) -> Disposable in
            guard let url = self.apiURLString else {
                return Disposables.create {
                    log.error("invalid url string")
                }
            }
            let request = Alamofire.request(url)
                .responseObject(completionHandler: { (response: DataResponse<Commit>) in
                    if let commit = response.result.value {
//                        self.commitFiles.value.append(contentsOf: commit.files)
                        observer.onNext(commit.files)
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
