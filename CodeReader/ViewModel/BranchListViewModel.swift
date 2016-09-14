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

class BranchListViewModel {
    
//    var branches = [(Branch, Commit)]()
    var branches = [Branch]()
    
    var ownerName: String!
    var repoName: String!
    
    init(ownerName: String, repoName: String) {
        
        self.ownerName = ownerName
        self.repoName = repoName
    }
    
    
    func loadLatestCommit(_ urlString: String, completion: @escaping (Commit)->(), errorHandler: ((String)->())? = nil) {
        Alamofire.request(.GET, urlString).responseJSON { res in
            if let commitJSON = res.result.value {
                if let commit = Mapper<Commit>().map(commitJSON) {
                    completion(commit)
                }
            }
        }
    }
    
    func loadBranches(completion: @escaping ()->(), errorHandler: ((String) -> ())? = nil) {
        let url = "https://api.github.com/repos/\(ownerName)/\(repoName)/branches"
        Alamofire.request(.GET, url)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode {
                        switch statusCode{
                        case 200..<299:
                            if let json = response.result.value {
                                if let items = Mapper<Branch>().mapArray(json) {
                                    self.branches.removeAll()
                                    self.branches.append(contentsOf: items)
                                    completion()
                                }
                            }
                        default:
                            if let errorHandler = errorHandler {
                                errorHandler("Status Code is wrong")
                            }
                        }
                        
                    }
                case .failure(let error):
                    log.error(error)
                    if let errorHandler = errorHandler {
                        errorHandler(error.localizedDescription)
                    }
                }
                
        }
    }
}
