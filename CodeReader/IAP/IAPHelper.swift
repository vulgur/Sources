//
//  IAPHelper.swift
//  CodeReader
//
//  Created by vulgur on 16/6/20.
//  Copyright © 2016年 MAD. All rights reserved.
//

import StoreKit
import Crashlytics


public typealias ProductRequestsCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject{
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    fileprivate var productIdentifiers: Set<String>
    fileprivate var purchasedProductIdentifiers = Set<String>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompeletionHandler: ProductRequestsCompletionHandler?
    
    public init(productIds: Set<String>) {
        self.productIdentifiers = productIds
        
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}


extension IAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductRequestsCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompeletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return false
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompeletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products")
        print("Error: \(error.localizedDescription)")
        
        productsRequestCompeletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    fileprivate func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompeletionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .failed:
                failedTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            default:
                break
            }
        }
    }
    
    fileprivate func completeTransaction(_ transaction: SKPaymentTransaction) {
        print("completeTransanction...")
        
        deliverPurchasedNotificationForIdentifier(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        Answers.logContentView(withName: "Purchase completed", contentType: "IAP", contentId: Date().dateString, customAttributes: nil)
    }
    
    fileprivate func restoreTransaction(_ transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {
            return
        }
        
        print("restoreTransaction... \(productIdentifier)")
        deliverPurchasedNotificationForIdentifier(productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        Answers.logContentView(withName: "Purchase restored", contentType: "IAP", contentId: Date().dateString, customAttributes: nil)
    }
    
    fileprivate func failedTransaction(_ transaction: SKPaymentTransaction) {
        print("failedTransaction...")
        if transaction.error!.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(transaction.error?.localizedDescription)")
            if let desc = transaction.error?.localizedDescription {
                Answers.logContentView(withName: "Purchase failed",
                                               contentType: "IAP",
                                               contentId: Date().dateString,
                                               customAttributes: ["Error": desc])
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    fileprivate func deliverPurchasedNotificationForIdentifier(_ identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}
