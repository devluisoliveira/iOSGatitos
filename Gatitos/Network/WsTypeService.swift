//
//  WsTypeService.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

// MARK: - WsTypeService
enum WsTypeService: String, CaseIterable {
    case raca
    case image
    
    public var urlTypeService: String {
        switch self {
        case .raca:
            gatitosBaseUrl = URLBase.currentUrl()
            return gatitosBaseUrl
        case .image:
            gatitosBaseUrl = URLBase.currentUrl()
            return gatitosBaseUrl
        }
    }
}
