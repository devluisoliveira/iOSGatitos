//
//  Connectivity.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation
import Alamofire

// MARK: - Retorna valor [Bool] se user esta conectado com a internet.
class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
