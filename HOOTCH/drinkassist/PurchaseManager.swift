//
//  PurchaseManager.swift
//  drinkassist
//
//  Created by Carl Henningsson on 11/25/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit

class PurchaseManaager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static var instance = PurchaseManaager()
    
    var IAP_REMOVE_ADS = "com.drinkassist.remove.ads"
    var IAP_GOLD = "com.drinkassist.gold"
    var IAP_PLATINUM = "com.drinkassist.platinum"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler?
    
    func fetchProducts() {
        let productIds = NSSet(objects: IAP_REMOVE_ADS, IAP_GOLD, IAP_PLATINUM) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseRemoveAds(onCompletion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onCompletion
            let removeAdsProducts = products[2]
            let payment = SKPayment(product: removeAdsProducts)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onCompletion(false)
        }
    }
    
    func purchaseGold(onCompletion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onCompletion
            let goldProduct = products[0]
            let payment = SKPayment(product: goldProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onCompletion(false)
        }
    }
    
    func purchasePlatinum(onCompetion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onCompetion
            let platinumProduct = products[1]
            let payment = SKPayment(product: platinumProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onCompetion(false)
        }
    }
    
    func restoreCompletedPurchases(onCompletion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() {
            transactionComplete = onCompletion
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            onCompletion(false)
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            products = response.products
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                } else if transaction.payment.productIdentifier == IAP_GOLD {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    UserDefaults.standard.set(true, forKey: IAP_GOLD)
                } else if transaction.payment.productIdentifier == IAP_PLATINUM {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    UserDefaults.standard.set(true, forKey: IAP_GOLD)
                    UserDefaults.standard.set(true, forKey: IAP_PLATINUM)
                }
                transactionComplete?(true)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                activityIndicator.stopAnimating()
                transactionComplete?(false)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                } else if transaction.payment.productIdentifier == IAP_GOLD {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    UserDefaults.standard.set(true, forKey: IAP_GOLD)
                } else if transaction.payment.productIdentifier == IAP_PLATINUM {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    UserDefaults.standard.set(true, forKey: IAP_GOLD)
                    UserDefaults.standard.set(true, forKey: IAP_PLATINUM)
                }
                transactionComplete?(true)
            default:
                transactionComplete?(false)
                break
            }
        }
    }
    
    func setUserDefaults(forKey: String) {
        UserDefaults.standard.set(true, forKey: forKey)
    }
}
