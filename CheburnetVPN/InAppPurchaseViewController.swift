//
//  InAppPurchaseViewController.swift
//  CheburnetVPN
//
//  Created by Анастасия on 28.04.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import UIKit
import StoreKit

class InAppPurchaseViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = 1
    
    let purchaseTypesArray = [Text.nameWeekPurchase, Text.nameMonthPurchase, Text.nameYearPurchase]
    let purchasePricesArray = ["699.88", "849.88", "5 499.88"]
    let namesDieWithPromotionArray = ["", Text.nameDieWithPopularPromotion, Text.nameDieWithCheapPromotion]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        IAService.shared.getProducts()
        IAService.shared.restorePurchases()
    }
    
    @IBAction func cancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payment(_ sender: Any) {
        IAService.shared.logEventInAppPurchase()
        switch selectedIndex {
        case 0: IAService.shared.purchase(product: .weekPurchase)
        case 1: IAService.shared.purchase(product: .monthPurchase)
        case 2: IAService.shared.purchase(product: .yearPurchase)
        default: IAService.shared.restorePurchases()
        }
    }
}

extension InAppPurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "purchaseCell", for: indexPath) as! PurchaseCollectionViewCell
        
        cell.purchaseType.text = purchaseTypesArray[indexPath.row]
        cell.purchasePrice.text = purchasePricesArray[indexPath.row] + " Р"
        cell.nameDieWithPromotion.text = namesDieWithPromotionArray[indexPath.row]

        switch indexPath.row {
        case 0:
            cell.dieWithPromotion.isHidden = true
        default:
            cell.dieWithPromotion.isHidden = false
        }
        
        cell.dieWithPromotion.backgroundColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
        cell.dieWithPromotion.layer.borderWidth = 2.0
        cell.dieWithPromotion.layer.cornerRadius = 12.5
        cell.dieWithPromotion.layer.borderColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
        
        cell.bgView.layer.borderWidth = 2.0
        cell.bgView.layer.cornerRadius = 15
        
        cell.checkmark.layer.cornerRadius = 12.5
        cell.checkmark.backgroundColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
        cell.checkmark.layer.borderColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
        cell.checkmark.layer.borderWidth = 2.0
        cell.circleInsideOfCheckmark.backgroundColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
        cell.circleInsideOfCheckmark.layer.cornerRadius = 5.5

        if selectedIndex == indexPath.row {
            cell.circleInsideOfCheckmark.backgroundColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
            cell.checkmark.layer.borderColor = UIColor.clear.cgColor
            cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.7496641278, green: 0, blue: 0.003165210597, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
            cell.thinView.layer.backgroundColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
        } else {
            cell.circleInsideOfCheckmark.backgroundColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
            cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.5669424534, green: 0, blue: 0, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
            cell.thinView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
        }
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
