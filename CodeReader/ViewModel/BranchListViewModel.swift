//
//  BranchListViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/9/6.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Bond
import Alamofire
import ObjectMapper

struct BranchListViewModel {
    
    var branches = [(Branch, Commit)]()
    
    var ownerName: String!
    var repoName: String!
    
    init(ownerName: String, repoName: String) {
        
        self.ownerName = ownerName
        self.repoName = repoName
    }
    
    mutating func loadLatestCommit(url: String) {
        
    }
    
    
    mutating func loadBranches(completion completion: ()->(), errorHandler: ((String) -> ())? = nil) {
        let url = "https://api.github.com/repos/\(ownerName)/\(repoName)/branches"
        Alamofire.request(.GET, url)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode {
                        switch statusCode{
                        case 200..<299:
                            if let json = response.result.value {
                                if let items = Mapper<Branch>().mapArray(json) {
                                    for branch in items {
                                        Alamofire.request(.GET, branch.latestCommitURLString!).responseJSON { res in
                                            if let commitJSON = res.result.value {
                                                if let commit = Mapper<Commit>().map(commitJSON) {
                                                    self.branches.append((branch, commit))
                                                }
                                            }
                                        }
                                    }
                                    completion()
                                }
                            }
                        default:
                            if let errorHandler = errorHandler {
                                errorHandler("Status Code is wrong")
                            }
                        }
                        
                    }
                case .Failure(let error):
                    log.error(error)
                    if let errorHandler = errorHandler {
                        errorHandler(error.localizedDescription)
                    }
                }
                
        }
    }
}