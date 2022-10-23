//
//  GatitosTableViewCell.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import UIKit

final class GatitosTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var label = UILabel().apply {
        $0.text = "Persa"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - CodeView

extension GatitosTableViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(label)
    }
    
    func setupConstraints() {
        label.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .systemGray3
        layer.cornerRadius = 4
    }
}
