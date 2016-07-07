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
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            let data: AnyObject
            switch type {
            case .Recent:
                data = NSKeyedArchiver.archivedDataWithRootObject(self.recents)
            case .Favorite:
                data = NSKeyedArchiver.archivedDataWithRootObject(self.favorites)
            }
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: type.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
            print("\(type.rawValue) saved")
        }
    }
    
//    func saveRecents() {
//        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
//            let recentsData = NSKeyedArchiver.archivedDataWithRootObject(self.recents)
//            NSUserDefaults.standardUserDefaults().setObject(recentsData, forKey: "recents")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            print("Recents saved")
//        }
//    }
//    
//    func saveFavorites() {
//        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
//            let favoritesData = NSKeyedArchiver.archivedDataWithRootObject(self.favorites)
//            NSUserDefaults.standardUserDefaults().setObject(favoritesData, forKey: "favorites")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            print("favorites saved")
//        }
//    }
    
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
    
    func addFavoriteFile(file: RepoFile) -> Bool {
        let ownerName = currentOwnerName ?? "Unknown"
        let repoName = currentRepoName ?? "Unknown"
        let favorite = Recent(file: file, ownerName: ownerName, repoName: repoName)
        if favorites.contains(favorite) {
            if let index = favorites.indexOf(favorite) {
                favorites.removeAtIndex(index)
            }
        }
        favorites.insert(favorite, atIndex: 0)
        if favorites.count <= maxCapacity {
            return true
        } else {
            favorites.removeLast()
            return false
        }
    }
}
