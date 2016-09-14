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
import Bond

struct CommitListViewModel {
    
    var commits = [Commit]()
    var isLoading = Observable<Bool>(false)
    
    var nextPageUrl: String = ""
    
    
    mutating func loadCommitList(_ urlString: String, completion: @escaping () -> (), errorHandler: (() -> ())? = nil) {
        // TODO: get he commit list of a specific branch
        Alamofire.request(.GET, urlString)
            .responseJSON { (response) in
                switch response.result{
                case .success:
                    if let items = Mapper<Commit>().mapArray(response.result.value) {
                        self.commits = items
                        completion()
                    }
                case .failure(let error):
                    print(error)
                }
                EZLoadingActivity.hide()
        }
    }
}
