//
//  GatitosViewModel.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 21/10/22.
//

import Foundation

// MARK: - GatitosNavigationProtocol - Use in Coordinator

protocol GatitosNavigationProtocol: AnyObject {
    func showGatitosDetails(objeto: GatitosResponse)
    func errorInternet(sender: NSDictionary, error: String, status: WsStatus, code: Int)
    func errorGeneric(sender: NSDictionary, error: String, status: WsStatus, code: Int)
}

// MARK: - GatitosViewModelProtocol - Protocol definition Use in Controller

protocol GatitosViewModelProtocol: ViewModelProtocol {
    var isLoading: Observable<Bool> { get }
    var isError: Observable<String?> { get }
    func showGatitosDetails(objeto: GatitosResponse)
    var gatitosResponse: Observable<[GatitosResponse]> { get }
}

// MARK: - GatitosViewModel

final class GatitosViewModel: GatitosViewModelProtocol {
    private var navigationDelegate: GatitosNavigationProtocol
    var isLoading: Observable<Bool>
    var isError: Observable<String?>
    var gatitosResponse: Observable<[GatitosResponse]>

    // MARK: - Initialization

    init(navigationDelegate: GatitosNavigationProtocol) {
        self.navigationDelegate = navigationDelegate
        self.isLoading = Observable(false)
        self.isError = Observable("")
        self.gatitosResponse = Observable([])
        self.getBreeds()
    }
    
    // MARK: - Helpers
    
    func showGatitosDetails(objeto: GatitosResponse) {
        navigationDelegate.showGatitosDetails(objeto: objeto)
    }
    
    private func getBreeds() {
        let service = Service()
        service.delegate = self
        service.getBreeds()
    }
}

// MARK: - WsDelegate

extension GatitosViewModel: WsDelegate {
    func wsFinishedWithSuccess(identifier: String, sender: NSDictionary, status: WsStatus, jsonResult: NSMutableArray) {
        if identifier == "getBreeds" {
            if status == .success {
                if let result = sender.value(forKey: "result") as? NSArray {
                    if result.count != 0 {
                        for resultItem in result {
                            let gatitosResponseUi = GatitosResponse.init(dict: resultItem as! NSDictionary)
                            gatitosResponse.value.append(gatitosResponseUi)
                        }
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self.navigationDelegate.errorGeneric(
                                sender: sender,
                                error: "Nenhuma raça cadastrada no momento. Tente novamente mais tarde.",
                                status: status,
                                code: 0
                            )
                        }
                    }
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.navigationDelegate.errorGeneric(
                        sender: sender,
                        error: "Algo deu errado. Tente novamente mais tarde.",
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
            navigationDelegate.errorInternet(sender: sender, error: error, status: status, code: code)
        } else {
            // TODO: Tratar Erro Genérico
            if status == .badRequest {
                navigationDelegate.errorGeneric(
                    sender: sender,
                    error: "Algo deu errado, tente novamente",
                    status: status,
                    code: code)
            } else {
                navigationDelegate.errorGeneric(sender: sender, error: error, status: status, code: code)
            }
        }
    }
}
