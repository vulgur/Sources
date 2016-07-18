//
//  RecentsManager.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import Foundation

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
    
    private var maxCapacity: Int {
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            return 50
        } else {
            return 5
        }
    }
    
    func save(type: SaveType) {
        var data: AnyObject?
        var shouldSave = false
        switch type {
        case .Recent:
            if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) && self.recents.count > 0 {
                shouldSave = true
                data = NSKeyedArchiver.archivedDataWithRootObject(self.recents)
            } else {
                shouldSave = false
            }
        case .Favorite:
            if self.favorites.count > 0 {
                shouldSave = true
                data = NSKeyedArchiver.archivedDataWithRootObject(self.favorites)
            } else {
                shouldSave = false
            }
        }
        
        if shouldSave {
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: type.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
            print("\(type.rawValue) saved")
        }
    }
    
    func addRecentFile(file: RepoFile) {
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
        } else {
            recents.removeLast()
        }
    }
    
    func addFavorite(recent: Recent) {
        let favorite = recent
        if favorites.contains(favorite) {
            if let index = favorites.indexOf(favorite) {
                favorites.removeAtIndex(index)
            }
        }
        favorites.insert(favorite, atIndex: 0)
//        if favorites.count <= maxCapacity {
//        } else {
//            favorites.removeLast()
//        }
    }
    
    func removeFavorite(recent: Recent) {
        assert(favorites.count > 0, "Favorites must not be empty")
        if let index = favorites.indexOf(recent) {
            favorites.removeAtIndex(index)
        }
    }
}
