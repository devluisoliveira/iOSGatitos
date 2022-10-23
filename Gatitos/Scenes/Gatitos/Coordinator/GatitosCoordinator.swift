//
//  GatitosCoordinator.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import UIKit

/// Define what type of flows can be started from this Coordinator
protocol GatitosCoordinatorProtocol: Coordinator {
    func showGatitosViewController()
}

/// App coordinator is the only one coordinator which will exist during app's life cycle
final class GatitosCoordinator: GatitosCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .start }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    func start() {
        showGatitosViewController()
    }
    
    deinit {
        print("GatitosCoordinator deinit")
    }
    
    func showGatitosViewController() {
        let viewModel = GatitosViewModel(navigationDelegate: self)
        let viewController = GatitosViewController(viewModel: viewModel)
        viewController.didSendEventClosure = { [weak self] event in
            if event == .start {
                self?.navigationController.popToRootViewController(animated: false)
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - GatitosNavigationProtocol
extension GatitosCoordinator: GatitosNavigationProtocol {
    func showGatitosDetails(objeto: GatitosResponse) {
        let gatitosDetailsCoordinator = GatitosDetailsCoordinator(navigationController)
        gatitosDetailsCoordinator.breed = objeto
        gatitosDetailsCoordinator.start()
    }
    
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

// MARK: - CoordinatorFinishDelegate

extension GatitosCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {}
}

// MARK: - ModalExceptionViewDelegate

extension GatitosCoordinator: ModalExceptionViewDelegate {
    func primaryButtonAction(identifier: String) {
        self.navigationController.dismiss(animated: false)
    }
}

// MARK: - BottomSheetViewControllerDelegate

extension GatitosCoordinator: BottomSheetViewControllerDelegate {
    func onCloseBottomSheet(_ viewController: BottomSheetViewController) {
        self.navigationController.dismiss(animated: false)
    }
}
