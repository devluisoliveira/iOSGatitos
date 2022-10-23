//
//  GatitosViewController.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import UIKit
import Lottie

final class GatitosViewController: UIViewController {
    
    //MARK: - Properties
    
    private var reuseIdentifier = "GatitosTableViewCell"
    private var viewModel: GatitosViewModelProtocol
    var didSendEventClosure: ((GatitosViewController.Event) -> Void)?
    
    let animationView = LottieAnimationView()
    
    private let tableView = UITableView(translateMask: false).apply {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.allowsSelection = true
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }
    
    //MARK: - Lifecycle
    
    init(viewModel:GatitosViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation(lottie: "splash")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.animationView.isHidden = true
            self.animationView.stop()
            self.setupViews()
            self.setupBindigs()
        }
    }
    
    // MARK: - Helpers
    
    private func setupAnimation(lottie: String) {
        animationView.animation = LottieAnimation.named(lottie)
        animationView.frame = view.bounds
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func setupBindigs() {
        viewModel.gatitosResponse.bind { [weak self] reasons in
            guard let self = self else { return }
            if !reasons.isEmpty {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
            }
        }
    }
}

//MARK: - Event

extension GatitosViewController {
    enum Event {
        case start
    }
}

// MARK: - CodeView

extension GatitosViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingLeft: 16,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: 16
        )
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        title = "Raças"
        tableView.register(GatitosTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GatitosViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gatitosResponse.value.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 8
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 4    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(
            x: cell.bounds.origin.x,
            y: cell.bounds.origin.y,
            width: cell.bounds.width,
            height: cell.bounds.height
        ).insetBy(
            dx: 0,
            dy: verticalPadding/2
        )
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GatitosTableViewCell
        cell.label.text = viewModel.gatitosResponse.value[indexPath.row].name
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showGatitosDetails(objeto: viewModel.gatitosResponse.value[indexPath.row])
    }
}
