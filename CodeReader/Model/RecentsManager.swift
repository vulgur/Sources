//
//  RecentsManager.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation
import Crashlytics

class RecentsManager {
    
    enum SaveType : String {
        case Recent = "recents"
        case Favorite = "favorites"
    }
    
    static let sharedManager = RecentsManager()
    
    var recents = [Recent]()
    var favorites = [Recent]()
    var currentRepoName: String?
    var currentOwnerName: String?
    
    fileprivate var maxCapacity: Int {
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            return 50
        } else {
            return 5
        }
    }
    
    func save(_ type: SaveType) {
        var data: AnyObject?
        var shouldSave = false
        switch type {
        case .Recent:
            if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) && self.recents.count > 0 {
                shouldSave = true
                data = NSKeyedArchiver.archivedData(withRootObject: self.recents) as AnyObject?
            } else {
                shouldSave = false
            }
        case .Favorite:
            if self.favorites.count > 0 {
                shouldSave = true
                data = NSKeyedArchiver.archivedData(withRootObject: self.favorites) as AnyObject?
            } else {
                shouldSave = false
            }
        }
        
        if shouldSave {
            UserDefaults.standard.set(data, forKey: type.rawValue)
            UserDefaults.standard.synchronize()
            print("\(type.rawValue) saved")
        }
    }
    
    func addRecentFile(_ file: RepoFile) {
        let ownerName = currentOwnerName ?? "Unknown"
        let repoName = currentRepoName ?? "Unknown"
        let recent = Recent(file: file, ownerName: ownerName, repoName: repoName)
        if recents.contains(recent) {
            if let index = recents.index(of: recent) {
                recents.remove(at: index)
            }
        }
        recents.insert(recent, at: 0)
        if recents.count <= maxCapacity {
        } else {
            recents.removeLast()
        }
    }
    
    func addFavoriteByFile(_ file: RepoFile) {
        let ownerName = currentOwnerName ?? "Unknown"
        let repoName = currentRepoName ?? "Unknown"
        let recent = Recent(file: file, ownerName: ownerName, repoName: repoName)
        if favorites.contains(recent) {
            if let index = favorites.index(of: recent) {
                favorites.remove(at: index)
            }
        }
        favorites.insert(recent, at: 0)
        Answers.logCustomEvent(withName: "favorite", customAttributes: ["from": "file"])
    }
    
    func addFavoriteByRecent(_ recent: Recent) {
        let favorite = recent
        if favorites.contains(favorite) {
            if let index = favorites.index(of: favorite) {
                favorites.remove(at: index)
            }
        }
        favorites.insert(favorite, at: 0)
        Answers.logCustomEvent(withName: "favorite", customAttributes: ["from": "recent"])
    }
    
    func removeFavoriteByRecent(_ recent: Recent) {
        assert(favorites.count > 0, "Favorites must not be empty")
        if let index = favorites.index(of: recent) {
            favorites.remove(at: index)
        }
    }
    
    func removeFavoriteByFile(_ file: RepoFile) {
        assert(favorites.count > 0, "Favorites must not be empty")
        var indexToDelete: Int = -1
        for (index, favorite) in favorites.enumerated() {
            if favorite.file == file {
                indexToDelete = index
                break
            }
        }
        if indexToDelete >= 0 {
            favorites.remove(at: indexToDelete)
        }
    }
}
