//
//  MenuViewController.swift
//  CheburnetVPN
//
//  Created by Анастасия on 08.05.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func partnershipProgram(_ sender: Any) {
    }
    
    @IBAction func tariffs(_ sender: Any) {
    }
    
    @IBAction func support(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
        
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Hello!")
            composeVC.setMessageBody("Hello from California!", isHTML: false)
             
            present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateTheApp(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func restorePurchases(_ sender: Any) {
        IAService.shared.restorePurchases()
    }
    
    @IBAction func termsOfUse(_ sender: Any) {
        guard let url = URL(string: "https://google.com") else { return }
        UIApplication.shared.open(url)
    }
}

