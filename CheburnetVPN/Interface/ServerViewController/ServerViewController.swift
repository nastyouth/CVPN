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
    var delegate: ServerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeButton(_ button: UIButton) {
        let puchaseDate = UserDefaults.standard.value(forKey: "expDate") as? Date
        let date = Date()
        guard let expDate = puchaseDate else { return }

        if (date < expDate) {
            button.backgroundColor = #colorLiteral(red: 0.2583432496, green: 0.6105024219, blue: 0, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            button.setTitle("Подключен", for: .normal)
            button.layer.borderColor = #colorLiteral(red: 0.03412435204, green: 0.4601569772, blue: 0, alpha: 1)
        } else {
            button.backgroundColor = #colorLiteral(red: 1, green: 0.7902676463, blue: 0, alpha: 1)
            button.titleLabel?.textColor = #colorLiteral(red: 0.5778941512, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

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
        
        changeButton(cell.buttonPremium)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(servers[indexPath.row].rawValue, forKey: Configuration.SERVERNAME_KEY)
        delegate?.fillServerData(servers[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
