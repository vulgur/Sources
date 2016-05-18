//
//  RepoViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/5/18.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Bond
import Alamofire

class RepoViewModel {
    let avatarImageURLString = Observable("")
    let repoName = Observable("")
    let repoDescription = Observable("")
    let repoStars = Observable(0)
    let repoWatchers = Observable(0)
    let repoForks = Observable(0)
    let repoOwner = Observable(Owner())
    
    init(repo: Repo) {
        avatarImageURLString.value = (repo.owner?.avatarURLString)!
        repoName.value = repo.name ?? ""
        repoDescription.value = repo.description ?? ""
        repoStars.value = repo.starsCount ?? 0
        repoWatchers.value = repo.watchersCount ?? 0
        repoForks.value = repo.forksCount ?? 0
        repoOwner.value = repo.owner!
    }
    
    
    func fetchWatchers() {
        let url = String(format: "https://api.github.com/repos/%@/%@/subscribers", repoOwner.value.name!, repoName.value)
        print(url)
        Alamofire.request(.GET, url)
        .responseJSON { (response) in
            if let watchers = response.result.value as? NSArray {
                self.repoWatchers.value = watchers.count
            }
        }
    }
}