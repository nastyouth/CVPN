//
//  IAService.swift
//  CheburnetVPN
//
//  Created by Apparat on 03.05.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import Foundation
import StoreKit
import Firebase
import NotificationCenter

class IAService: NSObject {
    
    private override init() {}
    
    var requestProd = SKProductsRequest()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    var productsPrice: [Float] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "priceAdded"), object: nil)
        }
    }
    
    static let shared = IAService()
    
    func getProducts() {
        let products: Set = [IAProduct.weekPurchase.rawValue,
                             IAProduct.monthPurchase.rawValue,
                             IAProduct.yearPurchase.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
        validateProductIdentifiers()
    }
    
    func purchase(product: IAProduct) {
            guard let productToPurchase = products.filter( { $0.productIdentifier == product.rawValue }).first else { return }
            let payment = SKPayment(product: productToPurchase)
            paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    func logEventInAppPurchase() {
        Analytics.logEvent("\(LogEvents.inAppPurchaseButtonPressed.rawValue)", parameters: nil)
    }
}

extension IAService: SKProductsRequestDelegate {

    func validateProductIdentifiers() {
        let productsRequest = SKProductsRequest(productIdentifiers: [])

        self.requestProd = productsRequest;
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
            productsPrice.append(Float(truncating: product.price))
            
            for invalidIdentifier in response.invalidProductIdentifiers {
                    print("invalidIdentifier", invalidIdentifier)
            }
        }
    }
}

extension IAService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transactions[0].error ?? "Ошибки транзакции нет!")
            print(transaction .transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
