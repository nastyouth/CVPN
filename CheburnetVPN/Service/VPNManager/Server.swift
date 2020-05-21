//
//  Server.swift
//  CheburnetVPN
//
//  Created by Анастасия on 21.05.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import Foundation

enum Server: String, CaseIterable {
    case dev0
    case amsterdam
    case stockholm
    case newyork
    case chicago
    case oslo
    case zurich
    case vienna
    case london
    
    var server: String {
        return self.rawValue + ".4ebur.net"
    }
}
