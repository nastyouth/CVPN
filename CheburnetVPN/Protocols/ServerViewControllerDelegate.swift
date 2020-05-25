//
//  ServerViewControllerDelegate.swift
//  CheburnetVPN
//
//  Created by Apparat on 20.05.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import Foundation

protocol ServerViewControllerDelegate {
    func fillServerData(_ server: String, _ serverName: String)
}

protocol IAPurchaseDelegate {
    func fillPurchasePrice(_purchaseArray: [Float])
}
