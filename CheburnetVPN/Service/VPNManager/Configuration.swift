//
//  File.swift
//  CheburnetVPN
//
//  Created by Apparat on 30.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import Foundation

class Configuration {
    static let SERVER_KEY = "SERVER_KEY"
    static let ACCOUNT_KEY = "ACCOUNT_KEY"
    static let PASSWORD_KEY = "PASSWORD_KEY"
    static let ONDEMAND_KEY = "ONDEMAND_KEY"
    static let PSK_KEY = "PSK_KEY"
    static let SERVERNAME_KEY = "SERVERNAME_KEY"
    static let SELECTEDSERVER_KEY = "SELECTEDSERVER_KEY"
    
    static let KEYCHAIN_PASSWORD_KEY = "KEYCHAIN_PASSWORD_KEY"
    
    public let server: String
    public let account: String
    public let password: String
    
    init(server: String, account: String, password: String) {
        self.server = server
        self.account = account
        self.password = password
    }
    
    func getPasswordRef() -> Data? {
        KeychainWrapper.standard.set(password, forKey: Configuration.KEYCHAIN_PASSWORD_KEY)
        return KeychainWrapper.standard.dataRef(forKey: Configuration.KEYCHAIN_PASSWORD_KEY)
    }
    
    static func loadFromDefaults() -> Configuration {
        let def = UserDefaults.standard
        let server = def.string(forKey: Configuration.SERVER_KEY) ?? ""
        let account = def.string(forKey: Configuration.ACCOUNT_KEY) ?? ""
        let password = def.string(forKey: Configuration.PASSWORD_KEY) ?? ""
        return Configuration(
            server: server,
            account: account,
            password: password)
    }
    
    func saveToDefaults() {
        let def = UserDefaults.standard
        def.set(server, forKey: Configuration.SERVER_KEY)
        def.set(account, forKey: Configuration.ACCOUNT_KEY)
        def.set(password, forKey: Configuration.PASSWORD_KEY)
        print("server", server)
    }
}
