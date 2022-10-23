//
//  GatitosModel.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation

// MARK: - GatitosResponse
public final class GatitosResponse {
    public var id: String
    public var description: String
    public var name: String
    public var temperament: String


    public init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.temperament = ""
    }

    public convenience init(dict: Any) {
        self.init()
        if let json = dict as? [String: Any] {
            self.id << json["id"]
            self.description << json["description"]
            self.name << json["name"]
            self.temperament << json["temperament"]
        }
    }
    
    public func getId() -> String {
        return id
    }
    
    public func getDescription() -> String {
        return description
    }
  
    public func getName() -> String {
        return name
    }
    
    public func getTemperament() -> String {
        return temperament
    }
}
