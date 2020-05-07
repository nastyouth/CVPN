//
//  ViewController.swift
//  CheburnetVPN
//
//  Created by Анастасия on 27.04.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {

    @IBOutlet weak var connectStatus: UILabel!
    @IBOutlet weak var connectButton: customButton!
    
    var isAllowed: Bool = true
    
    var isPresentSetupVPN: Bool = false
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vpnStateChanged(status: VPNManager.shared.status)
        VPNManager.shared.statusEvent.attach(self, ViewController.vpnStateChanged)
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

    func vpnStateChanged(status: NEVPNStatus) {
        switch status {
        case .disconnected, .invalid, .reasserting:
            connectButton.setTitle("Подключиться", for: .normal)
            connectStatus.isHidden = true
        case .connected:
            connectStatus.isHidden = true
            connectButton.setTitle("Отключиться", for: .normal)
        case .connecting:
            self.connectStatus.text = "Подключение..."
            connectStatus.isHidden = false
        case .disconnecting:
            connectStatus.text = "Отключение..."
        @unknown default:
            break
        }
    }
    
    @IBAction func connectToVPN(_ sender: Any) {
        if (VPNManager.shared.isDisconnected) {
            let config = Configuration(
                server: "ikev2.korzh.pro",
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

