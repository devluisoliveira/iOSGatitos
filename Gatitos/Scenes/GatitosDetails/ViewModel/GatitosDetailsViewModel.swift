//
//  GatitosDetailsViewModel.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import Foundation

// MARK: - GatitosDetailsNavigationProtocol - Use in Coordinator

protocol GatitosDetailsNavigationProtocol: AnyObject {
    func errorInternet(sender: NSDictionary, error: String, status: WsStatus, code: Int)
    func errorGeneric(sender: NSDictionary, error: String, status: WsStatus, code: Int)
}

// MARK: - GatitosDetailsViewModelProtocol - Protocol definition Use in Controller

protocol GatitosDetailsViewModelProtocol: ViewModelProtocol {
    var isLoading: Observable<Bool> { get }
    var isError: Observable<String?> { get }
    var imageResponse: Observable<[ImageResponse]> { get }
}

// MARK: - GatitosDetailsViewModel

final class GatitosDetailsViewModel: GatitosDetailsViewModelProtocol {
    private var navigationDelegate: GatitosDetailsNavigationProtocol
    var isLoading: Observable<Bool>
    var isError: Observable<String?>
    var imageResponse: Observable<[ImageResponse]>
    var raceId: String?

    // MARK: - Initialization

    init(navigationDelegate: GatitosDetailsNavigationProtocol, raceId: String? = nil) {
        self.navigationDelegate = navigationDelegate
        self.isLoading = Observable(false)
        self.isError = Observable("")
        self.imageResponse = Observable([])
        self.raceId = raceId
        self.getImage(raceId: raceId ?? "")
    }
    
    // MARK: - Helpers
    
    private func getImage(raceId: String) {
        self.isLoading.value = true
        let service = Service()
        service.delegate = self
        service.getImage(raceId: raceId)
    }
}

// MARK: - WsDelegate

extension GatitosDetailsViewModel: WsDelegate {
    func wsFinishedWithSuccess(identifier: String, sender: NSDictionary, status: WsStatus, jsonResult: NSMutableArray) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading.value = false
            if identifier == "getImage" {
                if status == .success {
                    if let result = sender.value(forKey: "result") as? NSArray {
                        if result.count != 0 {
                            for resultItem in result {
                                let imageResponseUi = ImageResponse.init(dict: resultItem as! NSDictionary)
                                self.imageResponse.value.append(imageResponseUi)
                            }
                        }
                        else {
                            self.navigationDelegate.errorGeneric(
                                sender: sender,
                                error: "Raça não possui imagem cadastrada.",
                                status: status,
                                code: 0
                            )
                        }
                    }
                }
                else {
                    self.navigationDelegate.errorGeneric(
                        sender: sender,
                        error: "Algo deu errado, infelizmente no momento não poderemos apresentar a imagem. Tente novamente mais tarde.",
                        status: status,
                        code: 0
                    )
                }
            }
        }
    }
    
    func wsFinishedWithError(identifier: String, sender: NSDictionary, error: String, status: WsStatus, code: Int) {
        self.isError.value = error
        self.isLoading.value = false
        if status == .noInternet {
            // TODO: Tratar Erro para sem internet
            navigationDelegate.errorInternet(
                sender: sender,
                error: error,
                status: status,
                code: code
            )
        } else {
            // TODO: Tratar Erro Genérico
            if status == .badRequest {
                navigationDelegate.errorGeneric(
                    sender: sender,
                    error: "Algo deu errado, tente novamente",
                    status: status,
                    code: code
                )
            } else {
                navigationDelegate.errorGeneric(
                    sender: sender,
                    error: error,
                    status: status,
                    code: code
                )
            }
        }
    }
}
