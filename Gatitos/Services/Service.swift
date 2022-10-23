//
//  Service.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation

class Service: WebService {
    override init() {
        super.init()
    }
    
    // MARK: - Obtém todas as raças
    func getBreeds() {
        super.identifier += "getBreeds"
        super.get(url: "breeds", .raca)
    }
    
    func getImage(raceId: String) {
        super.identifier += "getImage"
        super.get(url: "images/search?breed_ids=\(raceId)", .image)
    }
}
