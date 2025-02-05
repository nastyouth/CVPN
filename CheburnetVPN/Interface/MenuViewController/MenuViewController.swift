//
//  MenuViewController.swift
//  CheburnetVPN
//
//  Created by Apparat on 08.05.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var partnershipLabel: customButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partnershipLabel.isHidden = true
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

            composeVC.setToRecipients(["help@softpanda.ru"])
            composeVC.setSubject("Cheburnet VPN Help")
            composeVC.setMessageBody("Hi Cheburnet VPN Team! ...", isHTML: false)
             
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
        guard let url = URL(string: "http://softpanda.ru/privacy.html") else { return }
        UIApplication.shared.open(url)
    }
}

