//
//  SetupYourVPNViewController.swift
//  CheburnetVPN
//
//  Created by Анастасия on 06.05.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import UIKit
import NetworkExtension

class SetupYourVPNViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
// FIXME: копипаст кода
        if (VPNManager.shared.isDisconnected) {
            let config = Configuration(
                server: "ikev2.korzh.pro",
                account: "nano",
                password: "nanonano")
            VPNManager.shared.connectIKEv2(config: config) { error in
                print(error)
            }
            config.saveToDefaults()
        } else {
            VPNManager.shared.disconnect()
        }
        
    }


}
