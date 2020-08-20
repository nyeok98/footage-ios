//
//  Settings_DonateVC.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import StoreKit

class Settings_DonateVC: UIViewController {
    
    let productID = "ConsumableTest"

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestPurchase(_ sender: UIButton) {
        requestBikePurchase()
    }
 
    func requestBikePurchase() {
        let productRequest = SKProductsRequest(productIdentifiers: .init(arrayLiteral: productID))
        productRequest.delegate = self
        productRequest.start()
    }
    
}

extension Settings_DonateVC: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: print("defer")
            case .failed: print("fail")
            case .purchased: print("complete")
            case .purchasing: print("ing")
            case .restored: print("restored")
            default:
                break
            }
        }
    }
    
}

extension Settings_DonateVC: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product = response.products[0]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
}
