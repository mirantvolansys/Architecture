//
//  AppDelegate.swift
//  NetworkManager
//
//  Created by Yogesh Makwana on 15/07/19.
//  Copyright © 2019 Volansys Technologies. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Web Operation
let kInternetDown       = "Your internet connection seems to be down"
let kHostDown           = "Your host seems to be down"
let kTimeOut            = "The request timed out"
let kTokenExpire        = "Session expired - please login again."
let _appName            = "Network Manager"

enum ProjectEnvironment {
    case staging, production
    
    var baseUrl: String {
        switch self {
        case .staging:
            return "https://reqres.in/api/"
        case .production:
            //return "https://reqres.in/api/"
            return "https://api.imgur.com/"
        }
    }
}

/// AccessTokenAdapter
class AccessTokenAdapter: RequestAdapter {
    
    private let accessToken: String
    
    var authType = ""
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(authType + " " + accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

// MARK: Auth Token Methods
extension NetworkManager {
    
    func setAuthToken(token: String, authType: String) {
        let adapter = AccessTokenAdapter(accessToken: token)
        adapter.authType = authType
        manager.adapter = adapter
    }
    
    func removeAuthToken() {
        manager.adapter = nil
    }
}

/// Response call back type
typealias ResponseHandler = (_ json: Any?, _ statusCode: Int) -> Void
typealias ProgressHandler = ((Progress) -> Void)

let API = NetworkManager.shared

/// NetworkManager
class NetworkManager: NSObject {

    static var shared: NetworkManager = NetworkManager()
    var isLogEnabled = true
    var environment = ProjectEnvironment.staging
    
    private let manager: SessionManager
    private var networkManager: NetworkReachabilityManager
    private var headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
        //"Content-Type": "application/json"
    ]
    
    private var paramEncode: ParameterEncoding = URLEncoding.default
    private var successBlock: (String, HTTPURLResponse?, AnyObject?, ResponseHandler) -> Void
    private var errorBlock: (String, HTTPURLResponse?, NSError, ResponseHandler) -> Void
    
    static var logHandler: ((String) -> Void)?
    
    override init() {
        manager = Alamofire.SessionManager.default
        networkManager = NetworkReachabilityManager()!
        
        // Will be called on success of web service calls.
        successBlock = { (relativePath, res, respObj, block) -> Void in
            // Check for response it should be there as it had come in success block
            if let response = res { // Success block
                if let resp = respObj {
                    NetworkManager.logPrint(items: "\n------ Response (\(relativePath)) ------")
                    NetworkManager.logPrint(items: "\(resp)")
                }
                block(respObj, response.statusCode)
            } else {
                // There might me no case this can get execute
                block(nil, 404)
            }
        }
        
        // Will be called on Error during web service call
        errorBlock = { (relativePath, res, error, block) -> Void in
            
            if let response = res {
                NetworkManager.logPrint(items: "Response Code: \(response.statusCode)")
                NetworkManager.logPrint(items: "Error Code: \(error.code)")
                if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData {
                    let errorDict = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                    if errorDict != nil {
                        NetworkManager.logPrint(items: "Error(\(relativePath)): \(errorDict!)")
                        block(errorDict!, response.statusCode)
                        if response.statusCode == 401 { // Unauthorized
                            // Invalid Authentication : Need to redirect login screen
                        }
                    } else {
                        let code = response.statusCode
                        block(error, code)
                    }
                } else {
                    block(error, response.statusCode)
                }
                // If response not found rely on error code to find the issue
            } else if error.code == -1009 {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kInternetDown] as AnyObject, error.code)
                return
            } else if error.code == -1003 {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kHostDown] as AnyObject, error.code)
                return
            } else if error.code == -1001 {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kTimeOut] as AnyObject, error.code)
                return
            } else {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block(error, error.code)
            }
        }
        super.init()
        addInterNetListner()
    }
    
    deinit {
        networkManager.stopListening()
    }
    
    static func logPrint(items: Any...) {
        
        if NetworkManager.shared.isLogEnabled {
            for item in items {
                logHandler?(String(describing: item) + "\n")
                print(item)
            }
        }
    }
    
    /// Generate absolute URL from relative oath
    ///
    /// - Parameter relPath: relative URL
    /// - Returns: absolute URL
    /// - Throws: throws error if URL not valid
    private func getFullUrl(relPath: String) throws -> URL {
        do {
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www") {
                return try relPath.asURL()
            } else {
                return try (environment.baseUrl + relPath).asURL()
            }
        } catch let err {
            throw err
        }
    }
    
    /// Main request method
    ///
    /// - Parameters:
    ///   - relPath: relative URL
    ///   - method: method type (GET, POST, PUT, PATCH, DELETE)
    ///   - param: input parameters
    ///   - headers: request headers
    ///   - block: response callback
    /// - Returns: reuest object
    private func request(relPath: String, method: HTTPMethod, param: [String: Any]?, headers: HTTPHeaders?, block: @escaping ResponseHandler) -> DataRequest? {
        do {
            NetworkManager.logPrint(items: "\nURL: \(try getFullUrl(relPath: relPath).absoluteString)")
            NetworkManager.logPrint(items: "Params: ", param ?? "No input params")
            
            //NetworkManager.logPrint(items: "Headers: ", headers ?? "No Headers")
            let request = manager.request(try getFullUrl(relPath: relPath), method: method, parameters: param, encoding: paramEncode, headers: headers)
        
            return request.responseJSON { (resObj) in
                switch resObj.result {
                case .success:
                    if let resData = resObj.data {
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse {
                            NetworkManager.logPrint(items: errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    NetworkManager.logPrint(items: err)
                    if let resData = resObj.data, let strRes = String(data: resData, encoding: .utf8) {
                        NetworkManager.logPrint(items: strRes)
                    }
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
        } catch let error {
            NetworkManager.logPrint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
    /// Multipart image uploading
    ///
    /// - Parameters:
    ///   - relPath: relative URL
    ///   - imgs: pass key and image pair
    ///   - param: input parameters
    ///   - headers: request headers
    ///   - block: response callback
    ///   - progress: uploading progress callback
    func uploadImages(relPath: String, keyAndImage imgs: [String: UIImage?], param: [String: String]? = nil, headers: HTTPHeaders? = nil, block: @escaping ResponseHandler, progress: ProgressHandler?) {
        do {
            NetworkManager.logPrint(items: "Url: \(try getFullUrl(relPath: relPath))")
            NetworkManager.logPrint(items: "Param: \(String(describing: param))")
            manager.upload(multipartFormData: { (formData) in
                for imgObj in imgs {
                    if let imgData = imgObj.value?.jpegData(compressionQuality: 1) {
                        formData.append(imgData, withName: imgObj.key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                }
                if let _ = param {
                    for (key, value) in param! {
                        formData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            }, to: try getFullUrl(relPath: relPath), method: HTTPMethod.post, headers: (headers  ?? headers), encodingCompletion: { encoding in
                switch encoding {
                case .success(let req, _, _):
                    NetworkManager.logPrint(items: "---- Uploading ----")
                    req.uploadProgress(closure: { (prog) in
                        NetworkManager.logPrint(items: "\(prog.fractionCompleted)")
                        progress?(prog)
                    }).responseJSON { (resObj) in
                        switch resObj.result {
                        case .success:
                            if let resData = resObj.data {
                                do {
                                    let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                                    self.successBlock(relPath, resObj.response, res, block)
                                } catch let errParse {
                                    NetworkManager.logPrint(items: errParse)
                                    self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                                }
                            }
                            break
                        case .failure(let err):
                            NetworkManager.logPrint(items: err)
                            self.errorBlock(relPath, resObj.response, err as NSError, block)
                            break
                        }
                    }
                    break
                case .failure(let err):
                    NetworkManager.logPrint(items: err)
                    self.errorBlock(relPath, nil, err as NSError, block)
                    break
                }
            })
        } catch let err {
            self.errorBlock(relPath, nil, err as NSError, block)
        }
    }
    
    // MARK: - Request methods
    
    /// GET Method
    ///
    /// - Parameters:
    ///   - relPath: relative path of your end point
    ///   - param: input parameters
    ///   - header: request headers
    ///   - block: response handler
    /// - Returns: request object
    @discardableResult
    func getRequest(relPath: String, param: [String: Any]? = nil, header: HTTPHeaders? = nil, block: @escaping ResponseHandler) -> DataRequest? {
        return request(relPath: relPath, method: .get, param: param, headers: header ?? self.headers, block: block)
    }
    
    /// POST Method
    ///
    /// - Parameters:
    ///   - relPath: relative path of your end point
    ///   - param: input parameters
    ///   - header: request headers
    ///   - block: response handler
    /// - Returns: request object
    @discardableResult
    func postRequest(relPath: String, param: [String: Any]? = nil, header: HTTPHeaders? = nil, block: @escaping ResponseHandler) -> DataRequest? {
        return request(relPath: relPath, method: .post, param: param, headers: header ?? self.headers, block: block)
    }
    
    /// PUT Method
    ///
    /// - Parameters:
    ///   - relPath: relative path of your end point
    ///   - param: input parameters
    ///   - header: request headers
    ///   - block: response handler
    /// - Returns: request object
    @discardableResult
    func putRequest(relPath: String, param: [String: Any]? = nil, header: HTTPHeaders? = nil, block: @escaping ResponseHandler) -> DataRequest? {
        return request(relPath: relPath, method: .put, param: param, headers: header ?? self.headers, block: block)
    }
    
    /// PATCH Method
    ///
    /// - Parameters:
    ///   - relPath: relative path of your end point
    ///   - param: input parameters
    ///   - header: request headers
    ///   - block: response handler
    /// - Returns: request object
    @discardableResult
    func patchRequest(relPath: String, param: [String: Any]? = nil, header: HTTPHeaders? = nil, block: @escaping ResponseHandler) -> DataRequest? {
        return request(relPath: relPath, method: .patch, param: param, headers: header ?? self.headers, block: block)
    }
    
    /// DELETE Method
    ///
    /// - Parameters:
    ///   - relPath: relative path of your end point
    ///   - param: input parameters
    ///   - header: request headers
    ///   - block: response handler
    /// - Returns: request object
    @discardableResult
    func deleteRequest(relPath: String, param: [String: Any]? = nil, header: HTTPHeaders? = nil, block: @escaping ResponseHandler) -> DataRequest? {
        return request(relPath: relPath, method: .delete, param: param, headers: header ?? self.headers, block: block)
    }
}

// MARK: - Internet Availability
extension NetworkManager {
    
    private func addInterNetListner() {
        networkManager.startListening()
    }
    
    /// network availability handler
    ///
    /// - Parameter isConnected: get callback when internet status change.
    func reachabilityHandler(isConnected: ((Bool) -> Void)?) {
        networkManager.listener = { (status) in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
                isConnected?(false)
            } else {
                isConnected?(true)
            }
        }
    }
    
    /// For checking network availability
    ///
    /// - Returns: return true if internet is available else return false
    func isInternetAvailable() -> Bool {
        if networkManager.isReachable {
            return true
        } else {
            return false
        }
    }
}
