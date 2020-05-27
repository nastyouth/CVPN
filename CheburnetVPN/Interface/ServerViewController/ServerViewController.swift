//
//  ServerViewController.swift
//  CheburnetVPN
//
//  Created by Apparat on 27.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit
import NetworkExtension

class ServerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let servers = Server.allCases
    var selectedServer: Int?
    var delegate: ServerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedServer = UserDefaults.standard.value(forKey: Configuration.SELECTEDSERVER_KEY) as? Int
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPremiumAction(_ sender: UIButton) {
        let puchaseDate = UserDefaults.standard.value(forKey: "expDate") as? Date
        let date = Date()
        
        if puchaseDate == nil {
            self.performSegue(withIdentifier: "segueToIAPurchase", sender: self)
        }
        
        guard let expDate = puchaseDate else { return }
        
        if (date < expDate) && (VPNManager.shared.isDisconnected) {
            guard let server = selectedServer else { return }
            connectToSelectedServer(server)
            print(#function, server)
        }
    }
    
    func changeButton(_ button: UIButton, _ row: Int) {
        let puchaseDate = UserDefaults.standard.value(forKey: "expDate") as? Date
        let date = Date()
        guard let expDate = puchaseDate else { return }

        if (date < expDate) && (!VPNManager.shared.isDisconnected) && (selectedServer == row) {
            button.backgroundColor = #colorLiteral(red: 0.2583432496, green: 0.6105024219, blue: 0, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            button.setTitle("Подключен", for: .normal)
            button.layer.borderColor = #colorLiteral(red: 0.03412435204, green: 0.4601569772, blue: 0, alpha: 1)
        } else if (date < expDate) {
            button.backgroundColor = #colorLiteral(red: 1, green: 0.7913793325, blue: 0, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.5778941512, green: 0, blue: 0, alpha: 1), for: .normal)
            button.setTitle("Подключиться", for: .normal)
            button.layer.borderColor = #colorLiteral(red: 0.8470789194, green: 0.6418995261, blue: 0, alpha: 1)
        } else {
            button.backgroundColor = #colorLiteral(red: 1, green: 0.7902676463, blue: 0, alpha: 1)
            button.titleLabel?.textColor = #colorLiteral(red: 0.8516176939, green: 0.6416843534, blue: 0, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.5778941512, green: 0, blue: 0, alpha: 1), for: .normal)
            button.setTitle("Premium", for: .normal)
        }
    }
    
    func connectToSelectedServer(_ row: Int) {
        UserDefaults.standard.set(servers[row].rawValue, forKey: Configuration.SERVERNAME_KEY)
        UserDefaults.standard.set(row, forKey: Configuration.SELECTEDSERVER_KEY)
        
        selectedServer = UserDefaults.standard.value(forKey: Configuration.SELECTEDSERVER_KEY) as? Int
        
        tableView.reloadData()
        delegate?.fillServerData(servers[row])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableView
extension ServerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServerCell
        
        let image = UIImage(named: servers[indexPath.row].rawValue)
        cell.flag.image = image
        cell.countryName.text = servers[indexPath.row].countryCode + ", " + servers[indexPath.row].rawValue
        
        changeButton(cell.buttonPremium, indexPath.row)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectToSelectedServer(indexPath.row)
    }
}
