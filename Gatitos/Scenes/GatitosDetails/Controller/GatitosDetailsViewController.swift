//
//  GatitosDetailsViewController.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import UIKit
import Kingfisher
import Lottie

final class GatitosDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: GatitosDetailsViewModelProtocol
    var didSendEventClosure: ((GatitosDetailsViewController.Event) -> Void)?
    var breed: GatitosResponse?
    
    private lazy var scrollView = UIScrollView(translateMask: false).apply {
        $0.frame = self.view.bounds
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private var stackView = UIStackView()
    private var racaStackView = UIStackView()
    private var temperamentStackView = UIStackView()
    private var descriptionStackView = UIStackView()
    
    private lazy var racaImage = UIImageView(translateMask: false).apply {
        $0.contentMode = .scaleAspectFit
        $0.setHeight(height: 250)
    }
    
    private lazy var racaTitleLabel = UILabel(translateMask: false).apply {
        $0.text = "Race Name:"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .left
    }
    
    private lazy var racaDescriptionLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var temperamentTitleLabel = UILabel(translateMask: false).apply {
        $0.text = "Temperament: "
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .left
    }
    
    private lazy var temperamentDescriptionLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var descriptionTitleLabel = UILabel(translateMask: false).apply {
        $0.text = "Description:"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .left
    }
    
    private lazy var descriptionLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private var animationView = LottieAnimationView()
    
    //MARK: - Lifecycle
    
    init(viewModel:GatitosDetailsViewModelProtocol, breed: GatitosResponse?) {
        self.viewModel = viewModel
        self.breed = breed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindigs()
    }
    
    //MARK: - Helpers
    
    func setupBindigs() {
        viewModel.isLoading.bind { isLoading in
            if isLoading {
                self.setupAnimation(lottie: "loading")
            } else {
                self.animationView.isHidden = true
                self.animationView.stop()
            }
        }
        
        viewModel.imageResponse.bind { [weak self] reasons in
            guard let self = self else { return }
            if !reasons.isEmpty {
                self.racaImage.isHidden = false
                for reason in reasons {
                    let url = URL(string: reason.getUrl())
                    self.racaImage.kf.setImage(with: url)
                }
            } else {
                self.racaImage.image = UIImage(named: "icImageNotAvailable")
            }
        }
    }
    
    func setupAnimation(lottie: String) {
        animationView.animation = LottieAnimation.named(lottie)
        animationView.frame = view.bounds
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}

//MARK: - CodeView

extension GatitosDetailsViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollView)
        
        racaStackView = UIStackView(arrangedSubviews: [racaTitleLabel, racaDescriptionLabel])
        racaStackView.axis = .vertical
        racaStackView.alignment = .leading
        racaStackView.spacing = 4
        
        temperamentStackView = UIStackView(arrangedSubviews: [temperamentTitleLabel, temperamentDescriptionLabel])
        temperamentStackView.axis = .vertical
        temperamentStackView.alignment = .leading
        temperamentStackView.spacing = 4
        
        descriptionStackView = UIStackView(arrangedSubviews: [descriptionTitleLabel, descriptionLabel])
        descriptionStackView.axis = .vertical
        descriptionStackView.alignment = .leading
        descriptionStackView.spacing = 4
        
        stackView = UIStackView(arrangedSubviews: [racaImage, racaStackView, temperamentStackView, descriptionStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        
        stackView.anchor(
            top: scrollView.topAnchor,
            paddingTop: 16,
            left: view.leftAnchor,
            paddingLeft: 16,
            bottom: scrollView.bottomAnchor,
            paddingBottom: 16,
            right: view.rightAnchor,
            paddingRight: 16
        )
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        title = "Raças"
        racaDescriptionLabel.text = breed?.getName()
        temperamentDescriptionLabel.text = breed?.getTemperament()
        descriptionLabel.text = breed?.getDescription()
    }
}

//MARK: - Event
extension GatitosDetailsViewController {
    enum Event {
        case details
    }
}
