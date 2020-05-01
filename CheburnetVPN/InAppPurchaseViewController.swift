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
    
    let purchaseType = ["Недельная", "Месячная", "Годовая"]
    let purchasePrice = ["699.88", "849.88", "5 499.88"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
    
    @IBAction func cancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}

extension InAppPurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "purchaseCell", for: indexPath) as! PurchaseCollectionViewCell
        
        cell.purchaseType.text = purchaseType[indexPath.row]
        cell.purchasePrice.text = purchasePrice[indexPath.row]
        
        cell.dieWithPromotion.backgroundColor = #colorLiteral(red: 1, green: 0.7955260277, blue: 0.01263210829, alpha: 1)
        cell.dieWithPromotion.layer.borderWidth = 1.0
        cell.dieWithPromotion.layer.cornerRadius = 12.5
        
        cell.bgView.layer.borderWidth = 2.0
        cell.bgView.layer.cornerRadius = 15
        
        cell.checkmark.image = #imageLiteral(resourceName: "Checkmark2")
        
        if selectedIndex == indexPath.row {
            cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.7496641278, green: 0, blue: 0.003165210597, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.thinView.layer.backgroundColor = #colorLiteral(red: 0.5675660968, green: 0, blue: 0, alpha: 1)
            cell.checkmark.image = #imageLiteral(resourceName: "Checkmark1")
        } else {
            cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.5669424534, green: 0, blue: 0, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 1, green: 0.893938005, blue: 0.1681821942, alpha: 1)
            cell.thinView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.893938005, blue: 0.1681821942, alpha: 1)
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
