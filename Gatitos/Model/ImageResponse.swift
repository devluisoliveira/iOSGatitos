//
//  ImageResponse.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//


//MARK: - ImageResponse
public final class ImageResponse {
    public var url: String
    
    public init() {
        self.url = ""
    }

    public convenience init(dict: Any) {
        self.init()
        if let json = dict as? [String: Any] {
            self.url << json["url"]
        }
    }
    
    public func getUrl() -> String {
        return url
    }
}
