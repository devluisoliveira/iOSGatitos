//
//  DefaultButton.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 23/10/22.
//

import UIKit

public final class DefaultButton: UIButton {

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Headers
    
    public func buttonEnabled() {
        backgroundColor = .red
        setTitleColor(.white, for: .normal)
        isEnabled = true
        isUserInteractionEnabled = true
    }

    public func buttondisabled() {
        backgroundColor = .red
        alpha = 0.5
        setTitleColor(.white, for: .normal)
        isEnabled = false
        isUserInteractionEnabled = false
    }
}

// MARK: - CodeView

extension DefaultButton: CodeView {
    public func setupConstraints() {}

    public func setupAdditionalConfiguration() {
        backgroundColor = .red
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        layer.cornerRadius = 4
        isEnabled = true
        isUserInteractionEnabled = true
    }
}
