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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vpnStateChanged(status: VPNManager.shared.status)
        VPNManager.shared.statusEvent.attach(self, ViewController.vpnStateChanged)
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
            VPNManager.shared.connectIKEv2(config: config) { error in
                let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            config.saveToDefaults()
        } else {
            VPNManager.shared.disconnect()
        }
    }
}

