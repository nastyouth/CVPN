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
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameFastestServer: UILabel!
    
    var server: String?
    var serverName: String?
    
    var isAllowed: Bool = true
    let userDefaults = UserDefaults.standard
    var animationImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vpnStateChanged(status: VPNManager.shared.status)
        VPNManager.shared.statusEvent.attach(self, ViewController.vpnStateChanged)
        fillingAnimationImagesArray()
        setupUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToChooseServer" {
            let destanationVC = segue.destination as? ServerViewController
            destanationVC?.delegate = self
        }
    }
    
    func setupUserDefaults() {
        server = userDefaults.value(forKey: Configuration.SERVER_KEY) as? String ?? "dev0.4ebur.net"
        serverName = userDefaults.value(forKey: Configuration.SERVERNAME_KEY) as? String ?? "Los Angeles"
        self.flagImage.image = UIImage(named: serverName ?? "Los Angeles")
        self.nameFastestServer.text = serverName ?? "Los Angeles"
    }
    
    func segueToSetupYourVPNVC() {
        self.performSegue(withIdentifier: "setupYourVPN", sender: self)
    }
    
    // MARK: - Connect/Disconnect animation
    func fillingAnimationImagesArray() {
        for i in 0...59 {
            let image: UIImage = UIImage(named:"Seq_\(i)")!
            animationImages.append(image)
        }
    }
    
    func connectAnimation<T>(imageArray: [T]) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.checkEndConnection()
            self.flagImage.image = UIImage(named: self.serverName ?? "Los Angeles")
            self.nameFastestServer.text = self.serverName ?? "Los Angeles"
        })
        
        connectImageView.animationImages = imageArray as? [UIImage]
        connectImageView.animationDuration = 2.0
        connectImageView.animationRepeatCount = 1
        connectImageView.startAnimating()
        
        CATransaction.commit()
    }
    
    // MARK: - VPN connect
    func fillServerData(_ server: Server?) {
        self.server = server?.server
        self.serverName = server?.rawValue
        
        if self.server != userDefaults.value(forKey: Configuration.SERVER_KEY) as? String ?? "dev0.4ebur.net" && self.server != nil {
            VPNManager.shared.disconnect()
        }
    }
    
    // MARK: Reconnection
    func checkEndConnection() {
        if self.server != self.userDefaults.value(forKey: Configuration.SERVER_KEY) as? String ?? "dev0.4ebur.net" {
            if (VPNManager.shared.isDisconnected) {
                let config = Configuration(
                    server: self.server ?? "dev0.4ebur.net",
                    account: "nano",
                    password: "nanonano")
                
                VPNManager.shared.connectIKEv2(config: config) { error in }
                
                isAllowed = true
                userDefaults.set(true, forKey: "isAllowed")
                isAllowed = self.userDefaults.bool(forKey: "isAllowed")
                
                config.saveToDefaults()
            }
        }
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
                server: server ?? "dev0.4ebur.net",
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
            
            isAllowed = true
            userDefaults.set(true, forKey: "isAllowed")
            isAllowed = self.userDefaults.bool(forKey: "isAllowed")
            
            config.saveToDefaults()
        } else {
            VPNManager.shared.disconnect()
        }
    }
}

