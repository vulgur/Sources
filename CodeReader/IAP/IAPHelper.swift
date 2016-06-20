//
//  IAPHelper.swift
//  CodeReader
//
//  Created by vulgur on 16/6/20.
//  Copyright © 2016年 MAD. All rights reserved.
//

import StoreKit

public typealias ProductRequestsCompletionHandler = (success: Bool, products: [SKProduct]?) -> ()

public class IAPHelper : NSObject{
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    private var productIdentifiers: Set<String>
    private var purchasedProductIdentifiers = Set<String>()
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompeletionHandler: ProductRequestsCompletionHandler?
    
    public init(productIds: Set<String>) {
        self.productIdentifiers = productIds
        
        for productIdentifier in productIds {
            let purchased = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
}


extension IAPHelper {
    
    public func requestProducts(completionHandler: ProductRequestsCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompeletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    public func isProductPurchased(productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return false
    }
    
    public func restorePurchases() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
}


extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompeletionHandler?(success: true, products: products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(request: SKRequest, didFailWithError error: NSError) {
        print("Failed to load list of products")
        print("Error: \(error.localizedDescription)")
        
        productsRequestCompeletionHandler?(success: false, products: nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompeletionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                completeTransaction(transaction)
            case .Failed:
                failedTransaction(transaction)
            case .Restored:
                restoreTransaction(transaction)
            default:
                break
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        print("completeTransanction...")
        
        deliverPurchasedNotificationForIdentifier(transaction.payment.productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.originalTransaction?.payment.productIdentifier else {
            return
        }
        
        print("restoreTransaction... \(productIdentifier)")
        deliverPurchasedNotificationForIdentifier(productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        print("failedTransaction...")
        if transaction.error!.code != SKErrorCode.PaymentCancelled.rawValue {
            print("Transaction Error: \(transaction.error?.localizedDescription)")
        }
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func deliverPurchasedNotificationForIdentifier(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: identifier)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(IAPHelper.IAPHelperPurchaseNotification, object: identifier)
    }
}