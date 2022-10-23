//
//  ModalExceptionView.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 23/10/22.
//

import Foundation
import UIKit

// MARK: - ModalExceptionViewDelegate

protocol ModalExceptionViewDelegate: AnyObject {
    func primaryButtonAction(identifier: String)
}

class ModalExceptionView: UIView {

    //MARK: - Properties
    private lazy var stackView = UIStackView(translateMask: false).apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 24
        $0.alignment = .fill
    }

    private let feedbackIcon = UIImageView(translateMask: false).apply {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel(translateMask: false).apply {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private let descriptionLabel = UILabel(translateMask: false).apply {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }

    private lazy var buttonsStackView = UIStackView(translateMask: false).apply {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
    }

    private lazy var primaryButton = DefaultButton(translateMask: false).apply {
        $0.setTitle("OK", for: .normal)
        $0.addTarget(self, action: #selector(primaryButtonAction(_:)), for: .touchUpInside)
        $0.setHeight(height: 52)
    }

    private weak var delegate: ModalExceptionViewDelegate?
    private var identifier: String = ""

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Selectors
    
    @objc func primaryButtonAction(_ sender: UIButton) {
        self.delegate?.primaryButtonAction(identifier: self.identifier)
    }

    // MARK: - Helpers
    
    func configure(image: UIImage?,
                   title: NSMutableAttributedString? = nil,
                   description: NSMutableAttributedString? = nil,
                   primaryButtonLabel: String? = nil,
                   delegate: ModalExceptionViewDelegate,
                   buttonInverse: Bool? = nil,
                   identifier: String) {
        self.delegate = delegate
        self.identifier = identifier

        if let title = title {
            self.titleLabel.attributedText = title
        }

        if let description = description {
            self.descriptionLabel.attributedText = description
        }

        self.feedbackIcon.image = image?.withRenderingMode(.alwaysTemplate)
        self.feedbackIcon.tintColor = .red

        if let primaryButtonLabel = primaryButtonLabel {
            self.primaryButton.setTitle(primaryButtonLabel, for: .normal)
            if primaryButtonLabel.isEmpty {
                self.primaryButton.isHidden = true
            }
        }

        setupViews()
    }
}

// MARK: - CodeView

extension ModalExceptionView: CodeView {
    func buildViewHierarchy() {

        buttonsStackView = UIStackView(arrangedSubviews: [primaryButton])

        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 10

        stackView = UIStackView(arrangedSubviews: [feedbackIcon, titleLabel, descriptionLabel, buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        feedbackIcon.isHidden = feedbackIcon.image == nil

        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.anchor(top: topAnchor, paddingTop: 50,
                         leading: leadingAnchor, paddingLeft: 32,
                         bottom: bottomAnchor, paddingBottom: 32,
                         trailing: trailingAnchor, paddingRight: 32)

        feedbackIcon.anchor(height: 40)
    }

    func setupAdditionalConfiguration() {
        layer.cornerRadius = 25
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
    }
}
