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
            if productsPrice.count < products.count {
                productsPrice.append(Float(truncating: product.price))
            }
        }
    }
}

fileprivate func setPurchase(date: Date?, productId: String?) {
    var dateComponent = DateComponents()
    
    switch productId {
    case IAProduct.weekPurchase.rawValue: dateComponent.setValue(1, for: .weekOfMonth)
    case IAProduct.monthPurchase.rawValue: dateComponent.setValue(1, for: .month)
    case IAProduct.yearPurchase.rawValue: dateComponent.setValue(1, for: .year)
    default: break
    }
    
    let expirationDate = Calendar.current.date(byAdding: dateComponent, to: date ?? Date())
    UserDefaults.standard.set(expirationDate, forKey: "expDate")
    print((#function), UserDefaults.standard.value(forKey: "expDate") ?? "")
}

extension IAService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transactions[0].error ?? "Ошибки транзакции нет!")
            print(#function, transaction .transactionState.status(), transaction.payment.productIdentifier)
            
            let date = transaction.transactionDate
            
            switch transaction.transactionState {
            case .purchasing: break
            case .purchased: setPurchase(date: date, productId: transaction.payment.productIdentifier)
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
