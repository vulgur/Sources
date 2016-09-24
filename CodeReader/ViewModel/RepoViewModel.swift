//
//  RepoViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/5/18.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Alamofire

class RepoViewModel {
    let avatarImageURLString = Observable("")
    let name = Observable("")
    let description = Observable("")
    let stars = Observable(0)
    let watchers = Observable(0)
    let forks = Observable(0)
    let owner = Observable(User())
    let createdDate = Observable("")
    let updatedDate = Observable("")
    let language = Observable("")
    let ownerName = Observable("")
    let fullName = Observable("")
    let size = Observable(0)
    
    init(repo: Repo) {
        avatarImageURLString.value = (repo.owner?.avatarURLString)!
        name.value = repo.name ?? ""
        description.value = repo.description ?? ""
        stars.value = repo.starsCount ?? 0
        watchers.value = repo.watchersCount ?? 0
        forks.value = repo.forksCount ?? 0
        owner.value = repo.owner!
        createdDate.value = repo.createdDate ?? ""
        updatedDate.value = repo.pushedDate ?? ""
        language.value = repo.language ?? "Unknown"
        ownerName.value = repo.owner!.loginName ?? ""
        size.value = repo.size ?? 0
        fullName.value = repo.fullName ?? ""
    }
    
    
    func fetchWatchers() {
        let url = String(format: "https://api.github.com/repos/%@/%@/subscribers",
                         owner.value.loginName!, name.value)
        Alamofire.request(url).responseJSON { (response) in
            if let watchers = response.result.value as? NSArray {
                self.watchers.value = watchers.count
            }
        }
    }
}
