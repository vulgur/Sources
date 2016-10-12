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
    
    var commits = [Commit]()
    var isLoading = Variable<Bool>(false)
    
    var nextPageUrl: String = ""
    
    
    func loadCommitList(_ urlString: String, completion: @escaping () -> (), errorHandler: (() -> ())? = nil) {
        // TODO: get he commit list of a specific branch
        Alamofire.request(urlString)
            .responseJSON { (response) in
                switch response.result{
                case .success:
                    if let value = response.result.value as? [[String: Any]], let items = Mapper<Commit>().mapArray(JSONArray: value) {
                        self.commits = items
                        completion()
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
