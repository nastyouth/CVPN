//
//  ServerViewControllerDelegate.swift
//  CheburnetVPN
//
//  Created by Анастасия on 20.05.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import Foundation

protocol ServerViewControllerDelegate {
    func fillServer(_ server: String)
}

protocol IAPurchaseDelegate {
    func fillPurchasePrice(_purchaseArray: [Float])
}
