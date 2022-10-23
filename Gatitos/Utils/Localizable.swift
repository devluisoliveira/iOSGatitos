//
//  Strings.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 23/10/22.
//

import Foundation
import UIKit

public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return NSLocalizedString(self, comment: "My package title")
    }
}
