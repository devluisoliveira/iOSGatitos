//
//  Session.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation

public class GatitosUserManager {
    static private var user: GatitosUser?
    public var user: GatitosUser
    public static var shared = GatitosUserManager()
    
    private init() {
        guard let hasUser = GatitosUserManager.user else {
            let u = GatitosUser()
            self.user = u
            return
        }
        
        self.user = hasUser
    }
}

public class GatitosUser {
    
    public var appVersion: String {
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            return appVersion
        }
        return ""
    }
    
    public let osNameVersion: String = {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        
        let osName: String = {
#if os(iOS)
            return "iOS"
#elseif os(watchOS)
            return "watchOS"
#elseif os(tvOS)
            return "tvOS"
#elseif os(macOS)
            return "OS X"
#elseif os(Linux)
            return "Linux"
#else
            return "Unknown"
#endif
        }()
        
        return "\(osName) \(versionString)"
    }()
    
    public func parse(data: NSDictionary) {
        self.accessToken = data["accessToken"] as? String
        self.refreshToken = data["refreshToken"] as? String
    }
    
    public var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    public var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refreshToken")
        }
    }
    
    public var isLogged: Bool {
        get {
            let hasItem = UserDefaults.standard.bool(forKey: "USER_LOGGED")
            return hasItem
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_LOGGED")
        }
    }
    
    public var locality: String? {
        get {
            return UserDefaults.standard.string(forKey: "locality")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "locality")
            UserDefaults.standard.synchronize()
        }
    }
}
