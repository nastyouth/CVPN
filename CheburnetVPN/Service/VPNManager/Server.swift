//
//  Server.swift
//  CheburnetVPN
//
//  Created by Apparat on 21.05.2020.
//  Copyright © 2020 Apparat. All rights reserved.
//

import Foundation

enum Server: String, CaseIterable {
    case dev0 = "Los Angeles"
    case amsterdam = "Amsterdam"
    case stockholm = "Stockholm"
    case newyork = "New York"
    case chicago = "Chicago"
    case oslo = "Oslo"
    case zurich = "Zurich"
    case vienna = "Vienna"
    case london = "London"
    
    var server: String {
        switch self {
        case .dev0: return "dev0.4ebur.net"
        case .amsterdam: return "amsterdam.4ebur.net"
        case .stockholm: return "stockholm.4ebur.net"
        case .newyork: return "newyork.4ebur.net"
        case .chicago: return "chicago.4ebur.net"
        case .oslo: return "oslo.4ebur.net"
        case .zurich: return "zurich.4ebur.net"
        case .vienna: return "vienna.4ebur.net"
        case .london: return "london.4ebur.net"
        }
    }
}
