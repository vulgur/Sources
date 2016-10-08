//
//  RepoViewModel.swift
//  CodeReader
//
//  Created by vulgur on 16/5/18.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
//import RxCocoa

class RepoViewModel {
    let avatarImageURLString = Variable<String>("")
    let name = Variable<String>("")
    let description = Variable<String>("")
    let stars = Variable<Int>(0)
    let watchers = Variable<Int>(0)
    let forks = Variable<Int>(0)
    let owner = Variable<User>(User())
    let createdDate = Variable<String>("")
    let updatedDate = Variable<String>("")
    let language = Variable<String>("")
    let ownerName = Variable<String>("")
    let fullName = Variable<String>("")
    let size = Variable<Int>(0)
    
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
