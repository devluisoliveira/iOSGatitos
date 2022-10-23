//
//  Ws.swift
//  Gatitos
//
//  Created by Luis Eduardo Silva Oliveira on 22/10/22.
//

import Foundation
import Alamofire

protocol WsDelegate: AnyObject {
    func wsFinishedWithSuccess(identifier: String, sender: NSDictionary, status: WsStatus, jsonResult: NSMutableArray)
    func wsFinishedWithError(identifier: String, sender: NSDictionary, error: String, status: WsStatus, code: Int)
}

class WebService: NSObject, URLSessionDelegate {

    // MARK: - Properties
    weak var delegate: WsDelegate?
    var identifier: String = ""
    let timeout = gatitosTimeOut
    private var params = [String]()
    private var values = [String]()
    private var dataValue = [NSData]()
    private var dataFormat = [String]()
    private var data = [String]()
    private var status = -1
    private var header = [String]()
    private var headerValue = [String]()
    private var lastMethod = ""
    private var lastUrl = ""
    var restoreCacheIfNeeded = true
    var json: NSDictionary?
    var version: String = ""
    private let userManager = GatitosUserManager.shared

    // MARK: - LifeCycle

    override init() {
        super.init()
        let userManager = GatitosUserManager.shared.user
        if userManager.refreshToken != "" {
            if let accessToken = userManager.accessToken {
                self.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
                self.addHeader(name: "Cache-Control", value: gatitosCacheControl)
                self.addHeader(name: "x-api-key", value: gatitosKey)
            }
        }
    }

    //MARK: -  Start

    private func request(httpMethod: String, url: String, _ typeService: WsTypeService) {

        self.lastMethod = httpMethod
        self.lastUrl    = url

        var requestURLString = "\(typeService.urlTypeService)\(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)"


        if url.contains("https://") {
            requestURLString = url
        }

        var request = URLRequest.init(url: URL.init(string: requestURLString)!)
        request.httpMethod      = httpMethod
        request.timeoutInterval = timeout

        print("#######################################################\n")
        
        print(" ☎️ - REQUEST:\n")
        print(" 🤖 PATH: \(url)")
        print(" 🚀 METHOD: \(httpMethod)")
        print(" 🌐 URL: \(gatitosBaseUrl)\(url)")
        

        if self.header.count > 0 {
            print(" 🎯 HEADERS: ")
            for headerIndex in 0 ..< self.header.count {
                print("\(self.header[headerIndex]) : \(self.headerValue[headerIndex])")
                request.addValue(self.headerValue[headerIndex], forHTTPHeaderField: self.header[headerIndex])
            }
        }

        request = configRequest(httpMethod: httpMethod, request: &request)

        print("\n 📝 - RESPONSE:\n")

        let configuration = URLSessionConfiguration.default
        //Fix - Privacy Violation: Request / Response Caching
        configuration.requestCachePolicy = .reloadIgnoringCacheData

        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        let conn = session.dataTask(with: request) { (data, response, error) in

            //Fix - Privacy Violation: Request / Response Caching
            URLCache.shared.removeAllCachedResponses()

            // Status code
            if let response = response as? HTTPURLResponse {
                self.status = response.statusCode
            }

            if error == nil {
                do {
                    if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                        if let theJSONData = try? JSONSerialization.data(
                            withJSONObject: jsonResult,
                            options: .prettyPrinted) {
                            if let jsonText = String(data: theJSONData,
                                                     encoding: .ascii) {
                                DispatchQueue.main.async {
                                    print(jsonText)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    print(jsonResult)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                print(jsonResult)
                            }
                        }

                        DispatchQueue.main.async {
                            if self.getStatus() == .badRequest {
                                print(" ❌ - Finished With Error")
                                self.delegate?.wsFinishedWithError(
                                    identifier: self.identifier,
                                    sender: jsonResult,
                                    error: "\(self.getStatus())",
                                    status: self.getStatus(),
                                    code: self.getCode(self.getStatus())
                                )
                                print(" 🚦- Status Server: ")
                                print("  Message Error: \(error?.localizedDescription ?? "")")
                                print("  Status Server: \(self.getStatus()) ")
                                print("  Code: \(self.getCode(self.getStatus())) ")
                            } else {
                                print("\n ✅  - Finished With Success\n")
                                if self.lastUrl == "/auth/login" {
                                    self.userManager.user.isLogged = true
                                    self.userManager.user.parse(data: jsonResult)
                                }
                                self.delegate?.wsFinishedWithSuccess(
                                    identifier: self.identifier,
                                    sender: jsonResult,
                                    status: self.getStatus(), jsonResult: .init())
                            }
                        }
                    } else {
                        if let jsonResult: NSMutableArray = try JSONSerialization.jsonObject(
                            with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableArray {
                            let dict = NSMutableDictionary.init()
                            dict.setValue(jsonResult, forKey: "result")

                            // Delegate Success
                            DispatchQueue.main.async {
                                if let jsonString = try? JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted) {
                                    if let theJSONText = String(data: jsonString,
                                                                encoding: .ascii) {
                                        print(theJSONText)
                                    }
                                }
                                print("\n ✅  - Finished With Success\n")
                                self.delegate?.wsFinishedWithSuccess(
                                    identifier: self.identifier,
                                    sender: dict,
                                    status: self.getStatus(), jsonResult: jsonResult)
                            }
                        }
                    }
                } catch let error as NSError {

                    if self.getStatus() == .success ||
                        self.getStatus() == .noContent ||
                        self.getStatus() == .created ||
                        self.getStatus() == .accepted {
                        DispatchQueue.main.async {
                            print("\n ✅  - Finished With Success\n")
                            self.delegate?.wsFinishedWithSuccess(
                                identifier: self.identifier,
                                sender: NSDictionary(),
                                status: self.getStatus(),
                                jsonResult: .init())
                        }
                    } else {
                        print(" ❌ - Finished With Error")
                        // Delegate Error
                        DispatchQueue.main.async {
                            if response == nil {
                                self.delegate?.wsFinishedWithError(
                                    identifier: self.identifier,
                                    sender: NSDictionary(),
                                    error: error.localizedDescription,
                                    status: WsStatus.noInternet,
                                    code: -1)
                            } else {
                                if self.getStatus() == .badRequest {
                                    self.delegate?.wsFinishedWithError(
                                        identifier: self.identifier,
                                        sender: NSDictionary(),
                                        error: "Algo deu errado! Por favor tente novamente mais tarde.",
                                        status: self.getStatus(),
                                        code: -1)
                                } else {
                                    self.delegate?.wsFinishedWithError(
                                        identifier: self.identifier,
                                        sender: NSDictionary(),
                                        error: error.localizedDescription,
                                        status: self.getStatus(),
                                        code: -1)
                                }
                            }
                        }
                        print(" 🚦🚦- Status Server: ")
                        print("  Message Error: \(error.localizedDescription)")
                        print("  Status Server: \(self.getStatus()) ")
                        print("  Code: \(self.getCode(self.getStatus())) ")
                    }
                }
            } else {
                if let error = error as NSError? {
                    print(" ❌ - Finished With Error")
                    self.userManager.user.isLogged = false
                    DispatchQueue.main.async {
                        if error.code == NSURLErrorNotConnectedToInternet {
                            self.delegate?.wsFinishedWithError(
                                identifier: self.identifier,
                                sender: NSDictionary(),
                                error: "Sua conexão parece estar desativada, por favor verifique e tente novamente.",
                                status: WsStatus.noInternet,
                                code: -1)
                        } else {
                            self.delegate?.wsFinishedWithError(
                                identifier: self.identifier,
                                sender: NSDictionary(),
                                error: error.localizedDescription,
                                status: self.getStatus(),
                                code: -1)
                            print(" 🚦🚦🚦- Status Server: ")
                            print("  Message Error: \(error.localizedDescription)")
                            print("  Status Server: \(self.getStatus()) ")
                            print("  Code: \(-1) ")
                        }
                    }
                }
            }
        }
        conn.resume()
    }
}

extension WebService {
    //MARK: - Get Status and return Type
    private func getStatus() -> WsStatus {
        switch self.status {
        case 200: return .success
        case 201: return .created
        case 202: return .accepted
        case 204: return .noContent
        case 304: return .notModified
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 408: return .requestTimeOut
        case 500: return .internalServerError
        case 409: return .conflict
        default: return .undefined
        }
    }

    //MARK: - Get code and return Int
    private func getCode(_ status: WsStatus) -> Int {
        switch status {
        case .success: return 200
        case .created: return 201
        case .accepted: return 202
        case .noContent: return 204
        case .notModified: return 304
        case .badRequest: return 400
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .requestTimeOut: return 408
        case .internalServerError: return 500
        case .noInternet: return -1
        case .conflict: return 409
        case .undefined: return 99
        }
    }
}

extension WebService {
    func get(url: String, _ typeService: WsTypeService) {
        self.start(httpMethod: "GET", url: url, typeService)
    }
    
    func json(url: String, _ typeService: WsTypeService) {
        self.start(httpMethod: "JSON", url: url, typeService)
    }

    private func start(httpMethod: String, url: String, _ typeService: WsTypeService) {
        checkConnection(httpMethod: httpMethod, url: url, typeService)
    }

    func checkConnection(httpMethod: String, url: String, _ typeService: WsTypeService) {
        if Connectivity.isConnectedToInternet() {
            self.request(httpMethod: httpMethod, url: url, typeService)
        } else {
            DispatchQueue.main.async {
                self.delegate?.wsFinishedWithError(
                    identifier: self.identifier,
                    sender: NSDictionary(),
                    error: "Sua conexão parece estar desativada, por favor verifique e tente novamente.",
                    status: WsStatus.noInternet,
                    code: -1
                )
            }
        }
    }
}

extension WebService {

    // MARK: - Prepare Request and Return

    func configRequest(httpMethod: String, request: inout URLRequest) -> URLRequest {

        // MARK: - JSON

        if httpMethod == "JSON" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            if let json = self.json {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }

                if let jsonString = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    if let theJSONText = String(data: jsonString,
                                                encoding: .ascii) {
                        print(" 🅿️ PARAMS - \(theJSONText)")
                    }
                }
            }
        }

        return request
    }
}

extension WebService {
    // Add's
    func addHeader(name: String, value: String) {
        self.header.append(name)
        self.headerValue.append(value)
    }
}
