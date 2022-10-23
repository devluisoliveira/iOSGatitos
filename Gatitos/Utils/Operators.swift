//
//  Operators.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation

// Generic type for String and optional String
public func << <T>(left: inout String, right: T) {
    if let right = right as? String {
        left = right
    }
}
public func << <T>(left: inout String?, right: T) {
    if let right = right as? String {
        left = right
    }
}

// Generic type for Int and optional Int
public func << <T>(left: inout Int?, right: T) {
    if let right = right as? Int {
        left = right
    }
}
public func << <T>(left: inout Int, right: T) {
    if let right = right as? Int {
        left = right
    }
}

// Generic type for Bool and optional Bool
public func << <T>(left: inout Bool?, right: T) {
    if let right = right as? Bool {
        left = right
    }
}
public func << <T>(left: inout Bool, right: T) {
    if let right = right as? Bool {
        left = right
    }
}

// Generic type for Float and optional Float
public func << <T>(left: inout Float?, right: T) {
    if let right = right as? Float {
        left = right
    }
}
public func << <T>(left: inout Float, right: T) {
    if let right = right as? Float {
        left = right
    }
}

// Generic type for Double and optional Double
public func << <T>(left: inout Double?, right: T) {
    if let right = right as? Double {
        left = right
    }
}
public func << <T>(left: inout Double, right: T) {
    if let right = right as? Double {
        left = right
    }
}

// Generic type for String:Any and optional String:Any
public func << <T>(left: inout [String: Any], right: T) {
    if let right = right as? [String: Any] {
        left = right
    }
}
public func << <T>(left: inout [String: Any]?, right: T) {
    if let right = right as? [String: Any] {
        left = right
    }
}

// Generic type for String:Any and optional String:Any
public func << <T>(left: inout [[String: Any]], right: T) {
    if let right = right as? [[String: Any]] {
        left = right
    }
}
public func << <T>(left: inout [[String: Any]]?, right: T) {
    if let right = right as? [[String: Any]] {
        left = right
    }
}
