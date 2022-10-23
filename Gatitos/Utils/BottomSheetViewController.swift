//
//  BottomSheetViewController.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 23/10/22.
//

import Foundation
import UIKit

// MARK: - BottomSheetViewControllerDelegate

/**
 Delegate to be followed by the class that is implementing this component
 */
public protocol BottomSheetViewControllerDelegate: AnyObject {
    func onCloseBottomSheet(_ viewController: BottomSheetViewController)
}

/**
 Class that provides a bottom sheet view controller that grows conform childs' size
 */
public final class BottomSheetViewController: UIViewController {
    // MARK: - Views

    /**
     The rounded corners view
     */
    private let bottomView = UIView(frame: .zero)

    /**
     Content view to be shown in screen
     */
    private var contentView: UIView

    // MARK: - Instance properties

    /**
     Delegate to notify how is implementing this component
     */
    private weak var delegate: BottomSheetViewControllerDelegate?

    /**
     This property make a home indicator disappear after a few moments
     */
    public override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    /**
     Define NSLayoutConstraint form bottomView
     */
    private var bottomViewBottomContraint: NSLayoutConstraint?

    /**
     indicates if whether when viewDidAppear should animate bottom view or not
     */
    private let withAnimation: Bool

    // MARK: - Initialization

    /** Initializes a new bottom sheet view controller.
     - Parameters:
       - contentView: content view of bottom sheet
       - delegate: delegate to know when button is tapped
       - withAnimation: defines whether when viewDidAppear should animate bottom view or not
     */
    public init(contentView: UIView,
                delegate: BottomSheetViewControllerDelegate? = nil,
                withAnimation: Bool = true) {
        self.contentView = contentView
        self.delegate = delegate
        self.withAnimation = withAnimation

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if withAnimation {
            animateBottomView()
        }
    }

    /**
     override to check whether the device has a home indicator or not
     */
    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        if view.safeAreaInsets.bottom > 0 {
            roundBottonView(hasHomeIndicator: true)
        } else {
            roundBottonView(hasHomeIndicator: false)
        }
    }

    // MARK: - Functions

    /**
     Setup UI items
     */
    private func setup() {
        setupViews()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
    }

    private func animateBottomView() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            self.bottomViewBottomContraint?.constant = 0

            self.view.layoutIfNeeded()
        })
    }

    private func roundBottonView(hasHomeIndicator: Bool) {
        if hasHomeIndicator {
            bottomView.layer.cornerRadius = 40
        } else {
            bottomView.layer.cornerRadius = 10
        }
    }

    // MARK: - Actions

    /**
     Close bottom sheet by clicking outside it
     */
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: contentView),
                    point.y < 0 else {
            return
        }
        delegate?.onCloseBottomSheet(self)
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if withAnimation {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.bottomViewBottomContraint?.constant = self.view.frame.height / 2
                self.view.backgroundColor = .white
                self.view.layoutIfNeeded()

            }, completion: { _ in
                super.dismiss(animated: flag, completion: completion)
            })
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}

// MARK: - ViewConfiguration

extension BottomSheetViewController: CodeView {
    public func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        bottomViewBottomContraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height / 2)
        bottomViewBottomContraint?.isActive = true

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 32),
            contentView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
    }

    public func buildViewHierarchy() {
        bottomView.addSubview(contentView)
        view.addSubview(bottomView)
    }
}

extension BottomSheetViewController {
    
}

