//
//  GatitosDetailsCoordinator.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import UIKit

/// Define what type of flows can be started from this Coordinator
protocol GatitosDetailsCoordinatorProtocol: Coordinator {
    func showGatitosDetailViewController()
}

/// App coordinator is the only one coordinator which will exist during app's life cycle
final class GatitosDetailsCoordinator: GatitosDetailsCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .start }
    
    var breed: GatitosResponse?
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    func start() {
        showGatitosDetailViewController()
    }
    
    deinit {
        print("GatitosDetailsCoordinator deinit")
    }
    
    func showGatitosDetailViewController() {
        let viewModel = GatitosDetailsViewModel(navigationDelegate: self, raceId: breed?.id)
        let viewController = GatitosDetailsViewController(viewModel: viewModel, breed: breed)
        viewController.didSendEventClosure = { [weak self] event in
            if event == .details {
                self?.navigationController.popToRootViewController(animated: false)
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - GatitosDetailsNavigationProtocol

extension GatitosDetailsCoordinator: GatitosDetailsNavigationProtocol {
    func errorInternet(sender: NSDictionary, error: String, status: WsStatus, code: Int) {
        let modalExceptionView = ModalExceptionView()

        let title = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let description = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        title.append(NSAttributedString(string: Strings.Exceptions.noInternet,
                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                     NSAttributedString.Key.foregroundColor: UIColor.black]))

        description.append(NSAttributedString(string: Strings.Exceptions.itLooksLikeYouHaveNoInternet,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                           NSAttributedString.Key.foregroundColor: UIColor.black]))

        modalExceptionView.configure(image: Images.icAlertModal,
                                     title: title,
                                     description: description,
                                     primaryButtonLabel: Strings.Buttons.buttonOK.uppercased(),
                                     delegate: self,
                                     identifier: "")

        let bottomSheet = BottomSheetViewController(contentView: modalExceptionView, delegate: self)
        bottomSheet.modalPresentationStyle = .overCurrentContext

        navigationController.present(bottomSheet, animated: true)
        self.navigationController.view.backgroundColor = .white
    }

    func errorGeneric(sender: NSDictionary, error: String, status: WsStatus, code: Int) {
        let modalExceptionView = ModalExceptionView()

        let title = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let description = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        title.append(NSAttributedString(string: "",
                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
                                                     NSAttributedString.Key.foregroundColor: UIColor.black]))

        description.append(NSAttributedString(string: error.description,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                           NSAttributedString.Key.foregroundColor: UIColor.black]))

        modalExceptionView.configure(image: Images.icIconLogo,
                                     title: title,
                                     description: description,
                                     primaryButtonLabel: Strings.Buttons.buttonOK.uppercased(),
                                     delegate: self,
                                     identifier: "")

        let bottomSheet = BottomSheetViewController(contentView: modalExceptionView, delegate: self)
        bottomSheet.modalPresentationStyle = .overCurrentContext
        navigationController.present(bottomSheet, animated: false)
    }
}

// MARK: - ModalExceptionViewDelegate

extension GatitosDetailsCoordinator: ModalExceptionViewDelegate {
    func primaryButtonAction(identifier: String) {
        self.navigationController.dismiss(animated: false)
    }
}

// MARK: - BottomSheetViewControllerDelegate

extension GatitosDetailsCoordinator: BottomSheetViewControllerDelegate {
    func onCloseBottomSheet(_ viewController: BottomSheetViewController) {
        self.navigationController.dismiss(animated: false)
    }
}
