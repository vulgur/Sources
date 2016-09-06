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
    var branches = [Branch]()
    
    var ownerName: String!
    var repoName: String!
    
    init(ownerName: String, repoName: String) {
        
        self.ownerName = ownerName
        self.repoName = repoName
    }
    
    
    func loadBranches(completion completion: ()->(), errorHandler: ((String) -> ())? = nil) {
        let url = "https://api.github.com/repos/\(ownerName)/\(repoName)/branches"
        Alamofire.request(.GET, url)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode {
                        switch statusCode{
                        case 200..<299:
                            if let json = response.result.value {
                                log.info(json)
                                
                                // TODO: map the json to array
//                                completion()
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