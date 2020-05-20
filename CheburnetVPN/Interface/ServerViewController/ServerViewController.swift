//
//  ServerViewController.swift
//  CheburnetVPN
//
//  Created by Apparat on 27.04.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import UIKit
import NetworkExtension

//enum ServerData: String {
//    case dev0 = "dev0.4ebur.net"
//    case amsterdam = "amsterdam.4ebur.net"
//    case stockholm = "stockholm.4ebur.net"
//    case newyork = "newyork.4ebur.net"
//    case chicago = "chicago.4ebur.net"
//    case oslo = "oslo.4ebur.net"
//    case zurich = "zurich.4ebur.net"
//    case vienna = "vienna.4ebur.net"
//    case london = "london.4ebur.net"
//}

class ServerViewController: UIViewController {
    
    let servers = ["dev0.4ebur.net",
                   "amsterdam.4ebur.net",
                   "stockholm.4ebur.net",
                   "newyork.4ebur.net",
                   "chicago.4ebur.net",
                   "oslo.4ebur.net",
                   "zurich.4ebur.net",
                   "vienna.4ebur.net",
                   "london.4ebur.net"]
    
    let serversImageName = ["usa",
                            "Nor",
                            "Swe",
                            "usa",
                            "usa",
                            "nl",
                            "Che",
                            "Au",
                            "Eng"]
    
    let serverNames = ["Dev0",
                       "Amsterdam",
                       "Stockholm",
                       "New York",
                       "Chicago",
                       "Oslo",
                       "Zurich",
                       "Vienna",
                       "London"]

    @IBOutlet weak var tableView: UITableView!
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
        
        let image = UIImage(named: serversImageName[indexPath.row])
        cell.flag.image = image
        cell.countryName.text = serverNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        delegate?.fillServer(servers[row])
        dismiss(animated: true, completion: nil)
    }
}
