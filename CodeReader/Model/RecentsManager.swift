//
//  RecentsManager.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation

class RecentsManager {
    static let sharedManager = RecentsManager()
    var recents = [Recent]()
    var currentRepoName: String?
    var currentOwnerName: String?
    private var maxCapacity: Int {
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            return 50
        } else {
            return 5
        }
    }
    
    func saveRecents() {
        
    }
    
    func addRecentFile(file: RepoFile) -> Bool {
        let ownerName = currentOwnerName ?? "Unknown"
        let repoName = currentRepoName ?? "Unknown"
        let recent = Recent(file: file, ownerName: ownerName, repoName: repoName)
        if recents.contains(recent) {
            if let index = recents.indexOf(recent) {
                recents.removeAtIndex(index)
            }
        }
        recents.insert(recent, atIndex: 0)
        if recents.count <= maxCapacity {
            return true
        } else {
            recents.removeLast()
            return false
        }
    }
}
