//
//  AboutViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/6/17.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import StoreKit

class AboutViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var donateImageView: UIImageView!
    @IBOutlet var restoreButton: UIButton!
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(AboutViewController.handlePurchasedNotification(_:)), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            changeStateToPurchased()
        } else {
            EZLoadingActivity.show("loading...", disableUI: true)
            DonationProduct.store.requestProducts { (success, products) in
                if success {
                    EZLoadingActivity.hide()
                    self.products = products!
                    if let buyMeACoffee = self.products.first {
                        if DonationProduct.store.isProductPurchased(buyMeACoffee.productIdentifier) {
                            self.changeStateToPurchased()
                        } else {
                            let tap = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.tapToDonate))
                            self.donateImageView.isUserInteractionEnabled = true
                            self.donateImageView.addGestureRecognizer(tap)
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc fileprivate func handlePurchasedNotification(_ notification: Notification) {
        guard let identifier = notification.object as? String else { return }
        
        for product in products {
            guard product.productIdentifier == identifier else { continue }
            changeStateToPurchased()
        }
    }
    
    fileprivate func changeStateToPurchased() {
        UIView.transition(with: donateImageView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.donateImageView.image = UIImage(named: "purchased_coffee")
            self.titleLabel.text = "You've unlocked all features"
            }, completion: nil)
        donateImageView.isUserInteractionEnabled = false
        restoreButton.isHidden = true
    }
    
    @objc fileprivate func tapToDonate() {
        if let buyMeACoffee = self.products.first {
            DonationProduct.store.buyProduct(buyMeACoffee)
        }
    }

    @IBAction func restoreTapped(_ sender: UIButton) {
        DonationProduct.store.restorePurchases()
    }
}
