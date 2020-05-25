//
//  VPNManager.swift
//  CheburnetVPN
//
//  Created by Apparat on 30.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import Foundation
import NetworkExtension

final class VPNManager: NSObject {
    
    static let shared: VPNManager = {
        let instance = VPNManager()
        instance.manager.localizedDescription = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        instance.loadProfile(callback: nil)
        return instance
    }()
    
    let manager: NEVPNManager = { NEVPNManager.shared() }()
    
    public var isDisconnected: Bool {
        get {
            return (status == .disconnected) || (status == .reasserting) || (status == .invalid)
        }
    }
    
    public var status: NEVPNStatus { get { return manager.connection.status } }
    public let statusEvent = Subject<NEVPNStatus>()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(
                                                self,
                                                selector: #selector(VPNManager.VPNStatusDidChange(_:)),
                                                name: NSNotification.Name.NEVPNStatusDidChange,
                                                object: nil)
    }
    
    public func disconnect(completionHandler: (() -> Void)? = nil) {
        manager.onDemandRules = []
        manager.isOnDemandEnabled = false
        manager.saveToPreferences { _ in
            self.manager.connection.stopVPNTunnel()
            completionHandler?()
        }
    }
    
    @objc private func VPNStatusDidChange(_: NSNotification?) {
        statusEvent.notify(status)
        
        switch status {
        case .disconnected, .invalid, .reasserting:
            print(status, "disconnected")
        case .connected:
            print(status, "connected")
        case .connecting:
            print(status, "connecting")
        case .disconnecting:
            print(status, "disconnecting")
        @unknown default:
            break
        }
    }
    
    private func loadProfile(callback: ((Bool) -> Void)?) {
        manager.protocolConfiguration = nil
        manager.loadFromPreferences { error in
            if let error = error {
                NSLog("Ошибка при загрузке настроек: \(error.localizedDescription)")
                callback?(false)
            } else {
                callback?(self.manager.protocolConfiguration != nil)
            }
        }
    }
    
    private func saveProfile(callback: ((Bool) -> Void)?) {
        manager.saveToPreferences { error in
            if let error = error {
                NSLog("Ошибка при сохранении профиля: \(error.localizedDescription)")
                callback?(false)
            } else {
                callback?(true)
            }
        }
    }
    
    public func connectIKEv2(config: Configuration, onError: @escaping (String) -> Void) {
         print("NEVPNStatus", 9)
        let p = NEVPNProtocolIKEv2()
        
        p.serverAddress = config.server
        p.deadPeerDetectionRate = NEVPNIKEv2DeadPeerDetectionRate.medium
        p.username = config.account
        p.passwordReference = config.getPasswordRef()

        p.disconnectOnSleep = false
        p.disableMOBIKE = false
        p.disableRedirect = false
        p.enableRevocationCheck = false
        p.enablePFS = false
        p.useExtendedAuthentication = true
        p.useConfigurationAttributeInternalIPSubnet = false
        p.remoteIdentifier = config.server

        loadProfile { _ in
            self.manager.protocolConfiguration = p
            self.manager.isEnabled = true
            
            self.saveProfile { success in
                if !success {
                    onError("Не удается сохранить профиль.")
                    return
                }
                
                self.loadProfile() { success in
                    if !success {
                        onError("Не удается загрузить профиль.")
                        return
                    }
                    
                    let result = self.startVPNTunnel()
                    
                    if !result {
                        onError("Не удается подключиться.")
                    }
                }
            }
        }
    }
    
    private func startVPNTunnel() -> Bool {
        do {
            try self.manager.connection.startVPNTunnel()
            return true
        } catch NEVPNError.configurationInvalid {
            NSLog("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            NSLog("Failed to start tunnel (configuration disabled)")
        } catch {
            NSLog("Failed to start tunnel (other error)")
        }
        return false
    }
}

