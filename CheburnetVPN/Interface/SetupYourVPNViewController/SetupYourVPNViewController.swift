//
//  SetupYourVPNViewController.swift
//  CheburnetVPN
//
//  Created by Apparat on 06.05.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit
import NetworkExtension

class SetupYourVPNViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: копипаст кода
        if (VPNManager.shared.isDisconnected) {
            let config = Configuration(
                server: "dev0.4ebur.net",
                account: "nano",
                password: "nanonano")
            VPNManager.shared.connectIKEv2(config: config) { error in }
            config.saveToDefaults()
        } else {
            VPNManager.shared.disconnect()
        }
    }
}
