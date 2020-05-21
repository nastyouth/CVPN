//
//  ViewController.swift
//  CheburnetVPN
//
//  Created by Apparat on 27.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController, ServerViewControllerDelegate {
    
    @IBOutlet weak var connectStatus: UILabel!
    @IBOutlet weak var connectButton: customButton!
    @IBOutlet weak var connectImageView: UIImageView!
    
    var server: String?
    
    var isAllowed: Bool = true
    let userDefaults = UserDefaults.standard
    var animationImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vpnStateChanged(status: VPNManager.shared.status)
        VPNManager.shared.statusEvent.attach(self, ViewController.vpnStateChanged)
        fillingAnimationImagesArray()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToChooseServer" {
            let destanationVC = segue.destination as? ServerViewController
            destanationVC?.delegate = self
        }
    }
    
    // FIXME
    func fillServer(_ server: String) {
        self.server = server
    }
    
    func segueToSetupYourVPNVC() {
        self.performSegue(withIdentifier: "setupYourVPN", sender: self)
    }
    
    func checkIsAllowConnectToVPN() {
        if !isAllowed {
            segueToSetupYourVPNVC()
            isAllowed = userDefaults.bool(forKey: "isAllowed")
            print(isAllowed)
        }
    }

    func fillingAnimationImagesArray() {
        for i in 0...59 {
            let image: UIImage = UIImage(named:"Seq_\(i)")!
            animationImages.append(image)
        }
    }
    
    func connectAnimation<T>(imageArray: [T]) {
        connectImageView.animationImages = imageArray as? [UIImage]
        connectImageView.animationDuration = 2.0
        connectImageView.animationRepeatCount = 1
        connectImageView.startAnimating()
    }

    func vpnStateChanged(status: NEVPNStatus) {
        switch status {
        case .disconnected, .invalid, .reasserting:
            connectButton.setTitle(LocalizationText.connect, for: .normal)
            connectStatus.isHidden = true
            connectImageView.image = UIImage(named:"Seq_0")
        case .connected:
            connectStatus.isHidden = true
            connectButton.setTitle(LocalizationText.disconnect, for: .normal)
            connectImageView.image = UIImage(named:"Seq_59")
        case .connecting:
            connectAnimation(imageArray: animationImages)
            self.connectStatus.text = LocalizationText.connecting
            connectStatus.isHidden = false
            connectImageView.image = UIImage(named:"Seq_59")
        case .disconnecting:
            connectAnimation(imageArray: animationImages.reversed())
            connectStatus.text = LocalizationText.disconnecting
            connectImageView.image = UIImage(named:"Seq_0")
        @unknown default:
            break
        }
    }
    
    @IBAction func connectToVPN(_ sender: Any) {
        if (VPNManager.shared.isDisconnected) {
            let config = Configuration(
                server: userDefaults.value(forKey: Configuration.SERVER_KEY) as? String ?? "dev0.4ebur.net",
                account: "nano",
                password: "nanonano")
            
            if !isAllowed {
                segueToSetupYourVPNVC()
            }
            
            VPNManager.shared.connectIKEv2(config: config) { error in
                self.isAllowed = false
                self.userDefaults.set(false, forKey: "isAllowed")
                self.isAllowed = self.userDefaults.bool(forKey: "isAllowed")
            }
            
            config.saveToDefaults()
        } else {
            VPNManager.shared.disconnect()
        }
    }
}

