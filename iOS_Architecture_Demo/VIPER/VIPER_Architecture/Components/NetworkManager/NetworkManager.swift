//
//  AppDelegate.swift
//  NetworkManager
//
//  Created by Yogesh Makwana on 15/07/19.
//  Copyright © 2019 Volansys Technologies. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SystemConfiguration

// MARK: Web Operation
let kInternetDown       = "Your internet connection seems to be down"
let kHostDown           = "Your host seems to be down"
let kTimeOut            = "The request timed out"
let kAppName            = "Network Manager"

let keyStatus       = "status"
let keyMessage      = "message"
let resultOK        = 200

let httpPostMethod = HTTPMethod.post

let networkManager = NetworkManager.shared


// MARK: - Error Codes
struct ErrorCode {
    static let NoNetworkConnection = -1000
}

let noInternetError = NSError(domain: "", code: ErrorCode.NoNetworkConnection, userInfo: [NSLocalizedDescriptionKey: "Your internet connection seems to be down"])

/// AccessTokenAdapter
class AccessTokenAdapter: RequestAdapter {
    
    private let accessToken: String
    
    var authType = ""
    
    init (accessToken: String) {
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
        sessionManager.adapter = adapter
    }
    
    func removeAuthToken() {
        sessionManager.adapter = nil
    }
}

/// Response call back type
typealias ResponseHandler = (_ json: Any?, _ statusCode: Int) -> Void
typealias ProgressHandler = ((Progress) -> Void)

/// NetworkManager
class NetworkManager: NSObject {
    
    static var shared: NetworkManager = NetworkManager()
    var isLogEnabled = true
    var environment = ProjectEnvironment.staging
    
    private let sessionManager = Alamofire.SessionManager()
    
    var requestHeaders: HTTPHeaders {
        return [:]
    }
    
    private var networkManager: NetworkReachabilityManager?
    private var headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
        //"Content-Type": "application/json"
    ]
    
    private var paramEncode: ParameterEncoding = URLEncoding.default
    private var successBlock: (String, HTTPURLResponse?, AnyObject?, ResponseHandler) -> Void
    private var errorBlock: (String, HTTPURLResponse?, NSError, ResponseHandler) -> Void
    
    static var logHandler: ((String) -> Void)?
    
    override init() {
        
        print("NetworkManager init")
        networkManager = NetworkReachabilityManager()
        
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
                block([kAppName: kInternetDown] as AnyObject, error.code)
                return
            } else if error.code == -1003 {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block([kAppName: kHostDown] as AnyObject, error.code)
                return
            } else if error.code == -1001 {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block([kAppName: kTimeOut] as AnyObject, error.code)
                return
            } else {
                NetworkManager.logPrint(items: "Error(\(relativePath)): \(error)")
                block(error, error.code)
                return
            }
        }
        
        super.init()
        addInterNetListner()
    }
    
    deinit {
        networkManager?.stopListening()
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
            if !isInternetAvailable() {
                NetworkManager.logPrint(items: noInternetError.localizedDescription)
                errorBlock(relPath, nil, noInternetError, block)
                return nil
            }
            
            NetworkManager.logPrint(items: "\nURL: \(try getFullUrl(relPath: relPath).absoluteString)")
            NetworkManager.logPrint(items: "Params: ", param ?? "No input params")
            
            //NetworkManager.logPrint(items: "Headers: ", headers ?? "No Headers")
            let request = sessionManager.request(try getFullUrl(relPath: relPath), method: method, parameters: param, encoding: paramEncode, headers: headers)
            
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
                    
                case .failure(let err):
                    NetworkManager.logPrint(items: err)
                    if let resData = resObj.data, let strRes = String(data: resData, encoding: .utf8) {
                        NetworkManager.logPrint(items: strRes)
                    }
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
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
            sessionManager.upload(multipartFormData: { (formData) in
                for imgObj in imgs {
                    if let imgData = imgObj.value?.jpegData(compressionQuality: 1) {
                        formData.append(imgData, withName: imgObj.key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                }
                if param != nil {
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
                        case .failure(let err):
                            NetworkManager.logPrint(items: err)
                            self.errorBlock(relPath, resObj.response, err as NSError, block)
                        }
                    }
                case .failure(let err):
                    NetworkManager.logPrint(items: err)
                    self.errorBlock(relPath, nil, err as NSError, block)
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
        networkManager?.startListening()
    }
    
    /// network availability handler
    ///
    /// - Parameter isConnected: get callback when internet status change.
    func reachabilityHandler(isConnected: ((Bool) -> Void)?) {
        networkManager?.listener = { (status) in
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
        if networkManager!.isReachable {
            return true
        } else {
            return false
        }
    }
}

extension NetworkManager {
    func makeSimpleRequest(requestMethod: HTTPMethod, withApiUrl urlString: String, params: [String: Any], success: @escaping(String) -> Void, failure: @escaping(Error) -> Void) {
        
        // Check internet connection
        if !isInternetAvailable() {
            failure(noInternetError)
            return
        }
        let httpRequest = httpRequestBuilder(urlString: urlString, requestMethod: requestMethod, params: params)
        
        httpRequest.responseData { (dataResponse) in
            switch dataResponse.result {
                
            case .success(let data):
                
                if dataResponse.response?.statusCode == resultOK {
                    let message = String.init(data: data, encoding: .utf8)!
                    success(message)
                } else {
                    NetworkManager.parseFailureResponse(for: data, with: failure)
                }
                
            case .failure(let error):
                self.handleError(forRequest: httpRequest, error: error, with: dataResponse.data!, failure: failure)
            }
            
        }
    }
    
    // MARK: - Generic request for json object response
    func makeObjectRequest<T: BaseMappable>(forClass: T.Type, requestMethod: HTTPMethod, withApiUrl urlString: String, params: [String: Any], success: @escaping(DataResponse<T>) -> Void, failure: @escaping(Error) -> Void ) {
        
        // Check internet connection
        if !isInternetAvailable() {
            failure(noInternetError)
            return
        }
        
        let httpRequest = httpRequestBuilder(urlString: urlString, requestMethod: requestMethod, params: params)
        
        httpRequest.responseObject { (response: DataResponse<T>) in
            print("\(Date())Response: \(response)")
            
            switch response.result {
                
            case .success:
                success(response)
                
            case .failure(let error):
                self.handleError(forRequest: httpRequest, error: error, with: response.data!, failure: failure)
            }
        }
    }
    
    // MARK: - Generic request for json array response
    func makeArrayRequest<T: BaseMappable>(forClass: T.Type, requestMethod: HTTPMethod, withApiUrl urlString: String, params: [String: Any], success: @escaping([T]) -> Void, failure: @escaping (Error) -> Void) {
        
        // Check internet connection
        if !isInternetAvailable() {
            failure(noInternetError)
            return
        }
        
        let httpRequest = httpRequestBuilder(urlString: urlString, requestMethod: requestMethod, params: params)
        
        httpRequest.responseArray { (response: DataResponse<[T]>) in
            print("\(Date())Response: \(response)")
            
            switch response.result {
                
            case .success(let items):
                if response.response?.statusCode == resultOK {
                    success(items)
                } else {
                    NetworkManager.parseFailureResponse(for: response.data!, with: failure)
                }
            case .failure(let error):
                self.handleError(forRequest: httpRequest, error: error, with: response.data!, failure: failure)
            }
            
        }
    }
    
    func multipartDataRequest<T: BaseMappable>(urlString: String, forClass: T.Type, for fileData: Data?, with params: [String: String], success: @escaping(DataResponse<T>) -> Void, failure: @escaping (Error) -> Void) {
        
        // Check internet connection
        if !isInternetAvailable() {
            failure(noInternetError)
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            // append image data
            if let data = fileData {
                multipartFormData.append(data, withName: "profileImage", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            // append string data
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: urlString, headers: self.requestHeaders) { result in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseObject(completionHandler: { (response: DataResponse<T>) in
                    print("\(Date())Response: \(response)")
                    switch response.result {
                        
                    case .success:
                        success(response)
                        
                    case .failure(let error):
                        self.handleError(forRequest: upload, error: error, with: response.data!, failure: failure)
                    }
                })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func httpRequestBuilder(urlString: String, requestMethod: HTTPMethod, params: [String: Any]) -> DataRequest {
        print("\(requestMethod) Url: \(urlString)")
        print("Params: \(params)")
        print("Request Headers: \(requestHeaders)")
        
        let httpRequest = sessionManager.request(urlString,
                                                 method: requestMethod,
                                                 parameters: params,
                                                 encoding: requestMethod == .get ? URLEncoding.default : JSONEncoding.default,
                                                 headers: requestHeaders)
        
        // log reponse string as object mapper failed to parsing response
        httpRequest.responseString { response in
            
            if !response.result.isSuccess || response.response?.statusCode != resultOK {
                printError(logMessage: "Error : \(response.result.value ?? "No response")")
            } else {
                printError(logMessage: "Success:\n \(urlString) : \(response.result.isSuccess)")
            }
            
            #if DEBUG
            print("Request URL : \(response.request!.url!)")
            print("\(Date())Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value ?? "no response")")
            #endif
        }
        
        return httpRequest
    }
    
    // this funcation will convert data into json object and parse data and create a error object and pass to the failure block
    static func parseFailureResponse(for data: Data, with failure: @escaping (Error) -> Void) {
        if let json = getJsonString(from: data) {
            if let status = json[keyStatus] as? Int, let message = json[keyMessage] as? String {
                let error = NSError(domain: KEYDOMAIN, code: status, userInfo: [NSLocalizedDescriptionKey: message])
                if error.code == 412 {
                }
                failure(error)
            }
        } else {
            failure(NSError(domain: KEYDOMAIN, code: -1, userInfo: [NSLocalizedDescriptionKey: ""]))
        }
    }
    
    // this funcation will convert data in json object
    static func getJsonString(from data: Data) -> [String: Any]? {
        if let json = try? (JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]) {
            return json
        }
        return nil
    }
    
    func handleError(forRequest: DataRequest, error: Error, with data: Data, failure: @escaping (Error) -> Void) {
        let nserror = error as NSError
        if nserror.domain == "com.alamofireobjectmapper.error" {
            NetworkManager.parseFailureResponse(for: data, with: failure)
        } else {
            failure(error)
        }
    }
}
