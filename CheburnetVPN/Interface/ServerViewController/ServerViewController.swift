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
        cell.countryName.text = servers[indexPath.row].rawValue.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = servers[indexPath.row].server
        UserDefaults.standard.set(server, forKey: Configuration.SERVER_KEY)
        delegate?.fillServer(server)
        dismiss(animated: true, completion: nil)
    }
}
