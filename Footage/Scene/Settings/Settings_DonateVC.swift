//
//  Settings_DonateVC.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import StoreKit

class Settings_DonateVC: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    
    let productIDs = ["co.el.iap.bike", "co.el.iap.coffee", "co.el.iap.rice"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.layer.cornerRadius = 10
        SKPaymentQueue.default().add(self)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestPurchase(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productIDs[sender.tag]
            switch sender.tag {
            case 0: message.text = "자전거를 대여하는 중입니다"
            case 1: message.text = "커피를 내리는 중입니다"
            case 2: message.text = "따뜻한 밥을 짓는 중입니다"
            default: return
            }
            SKPaymentQueue.default().add(paymentRequest)
        }
    }
}

extension Settings_DonateVC: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                progressView.isHidden = false
                indicator.startAnimating()
                for button in buttons { button.isUserInteractionEnabled = false }
            default:
                queue.finishTransaction(transaction)
                indicator.stopAnimating()
                progressView.isHidden = true
                for button in buttons { button.isUserInteractionEnabled = true }
            }
        }
    }
    
}

//extension Settings_DonateVC: SKProductsRequestDelegate {
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let product = response.products[0]
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//
//}
//        let productRequest = SKProductsRequest(productIdentifiers: .init(arrayLiteral: productID))
//        productRequest.delegate = self
//        productRequest.start()
