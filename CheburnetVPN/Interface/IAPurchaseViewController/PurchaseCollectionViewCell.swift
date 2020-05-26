//
//  PurchaseCollectionViewCell.swift
//  CheburnetVPN
//
//  Created by Apparat on 28.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit

class PurchaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var purchaseType: UILabel!
    @IBOutlet weak var purchasePrice: UILabel!
    @IBOutlet weak var thinView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dieWithPromotion: UIView!
    @IBOutlet weak var nameDieWithPromotion: UILabel!
    @IBOutlet weak var checkmark: UIView!
    @IBOutlet weak var circleInsideOfCheckmark: UIView!
}
