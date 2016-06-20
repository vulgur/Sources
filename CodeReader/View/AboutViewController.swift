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

    @IBOutlet var donateImageView: UIImageView!
    @IBOutlet var restoreButton: UIButton!
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AboutViewController.handlePurchasedNotification(_:)), name: IAPHelper.IAPHelperPurchaseNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        EZLoadingActivity.show("Loading...", disableUI: true)
        DonationProduct.store.requestProducts { (success, products) in
            if success {
                EZLoadingActivity.hide()
                self.products = products!
                if let buyMeACoffee = self.products.first {
                    if DonationProduct.store.isProductPurchased(buyMeACoffee.productIdentifier) {
                        self.changeStateToPurchased()
                    } else {
                        let tap = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.tapToDonate))
                        self.donateImageView.userInteractionEnabled = true
                        self.donateImageView.addGestureRecognizer(tap)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func handlePurchasedNotification(notification: NSNotification) {
        guard let identifier = notification.object as? String else { return }
        
        for product in products {
            guard product.productIdentifier == identifier else { continue }
            changeStateToPurchased()
        }
    }
    
    private func changeStateToPurchased() {
        UIView.transitionWithView(donateImageView, duration: 0.5, options: [.TransitionCrossDissolve], animations: {
            self.donateImageView.image = UIImage(named: "purchased_coffee")
            }, completion: nil)
        donateImageView.userInteractionEnabled = false
        restoreButton.hidden = true
    }
    
    @objc private func tapToDonate() {
        if let buyMeACoffee = self.products.first {
            DonationProduct.store.buyProduct(buyMeACoffee)
        }
        
    }

    @IBAction func restoreTapped(sender: UIButton) {
        DonationProduct.store.restorePurchases()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
