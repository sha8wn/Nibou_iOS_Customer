import UIKit
import Foundation
import Alamofire
import MBProgressHUD

enum WebServiceResponseType{
    case Success
    case Failure
    case SomethingWentWrong
    case None
}

enum AuthorizationType{
    case basic
    case auth
}

public class Network: NSObject
{
    //MARK: - Properties
    static let shared       : Network                   = Network()
    var responseData        : NSMutableData             = NSMutableData()
    var responseType        : WebServiceResponseType!
    let appVersion          : String                    = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var Base64                                          = "FIFUser:FIFUser".toBase64()
    var delegates                                       = UIApplication.shared.delegate as! AppDelegate
    var HttpHeaders                                     = ["":""]
    var accessTokenModel    : LoginModel!
    var unauthUrlPath       : String                    = ""
    var unauthMethods       : HTTPMethod!
    var unauthParams        : [String : AnyObject]?
    var unauthType          : AuthorizationType!
    
    
    var unauthMultipath_ParamsName  : [String]?
    var unauthMultipath_File        : [Data]?
    var unauthMultipath_FileName    : [String]?
    var unauthMultipath_MineType    : [String]?
    var unauthMultipath_UploadDict  : [String: Any]?

    let JSONdecoder                                     = JSONDecoder()
    //end
    
    func request(urlPath: String, methods: HTTPMethod, authType: AuthorizationType, params: [String : AnyObject]? = nil, completion:@escaping (_ response: DataResponse<Any>?, _ message: String?, _ statusCode: Int, _ status: WebServiceResponseType) -> Void)
    {
        self.accessTokenModel = getAccessTokenModel()
        if(Reachability.isConnectedToNetwork()){

            if authType == AuthorizationType.basic{
                HttpHeaders = ["Content-Type"           : "application/json",
                               "X-App-Lang"             : "\(getCurrentLanguage())"
                ]
            }else if authType == AuthorizationType.auth{
                HttpHeaders = ["Content-Type"           : "application/json",
                               "X-App-Lang"             : "\(getCurrentLanguage())",
                               "Authorization"          : "Bearer \(self.accessTokenModel.accessToken)"
                ]
            }
            
            print("---------------------")
            print("URL: ", "\(urlPath)")
            print("HttpHeaders: ", "\(HttpHeaders)")
            print("Request: ", params ?? "")
            
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
            Alamofire.request(urlPath, method: methods, parameters: params, encoding: JSONEncoding.default, headers: HttpHeaders).responseJSON { (responseObject) -> Void in

                if urlPath.contains(kForgotPassword){
                    completion(responseObject, "SUCCESS", 200, .Success)
                }
                
                let (status, statusCode, message, _) = handleError(response: responseObject)

                if let resJson = responseObject.result.value as? NSDictionary{
                    print("Reponse: ", resJson)
                    print("StatusCode: ", statusCode)
                    print("---------------------")
                }else{
                    print("StatusCode: ", statusCode)
                    print("---------------------")
                }
                
                if status == .Success{
                    completion(responseObject, message, statusCode, status)
                }else{
                    if statusCode == 401{
                        self.accessTokenModel = getAccessTokenModel()
                        self.unauthUrlPath = urlPath
                        self.unauthMethods = methods
                        self.unauthParams = params
                        self.unauthType = authType
                        
                        let refreshToken = "\(self.accessTokenModel.refreshToken)"
                        let urlPath = kBaseURL + kAccessToken + "?grant_type=refresh_token&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&refresh_token=" + refreshToken
                        
                        self.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
    
                            if statusCode == 200{
                                do {
                                    let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())
                                    setAccessTokenModel(model: data)
                                    self.request(urlPath: self.unauthUrlPath, methods: self.unauthMethods, authType: self.unauthType, params: self.unauthParams, completion: { (refreshResponse, refreshMessage, refreshStatusCode, refreshStatus) in
                                        completion(refreshResponse, refreshMessage, refreshStatusCode, refreshStatus)
                                    })
                                } catch let error {
                                    print(error.localizedDescription)
                                    completion(response, "SOMETHING_WENT_WRONG".localized(), kSomethingWentWrongErrorCode, .Failure)
                                }
                            }else{
                                completion(response, message, statusCode, status)
                            }
                        }
                    }else{
                        completion(responseObject, message, statusCode, status)
                    }
                }
            }
        }else{
            completion(nil , "INTERNET".localized(), kInternetErrorCode, .Failure)
        }
    }
    
    
    func multipartRequest(urlPath: String, methods: HTTPMethod, paramName: [String]?, fileData: [Data]?, fileName: [String]?, mineType: [String]?, uploadDict: [String: Any]? = nil, completion:@escaping (_ response: DataResponse<Any>?, _ message: String?, _ statusCode: Int, _ status: WebServiceResponseType) -> Void) {
        
        self.accessTokenModel = getAccessTokenModel()
        if(Reachability.isConnectedToNetwork()){
            HttpHeaders = ["Content-Type"           : "application/json",
                           "X-App-Lang"             : "\(getCurrentLanguage())",
                "Authorization"          : "Bearer \(self.accessTokenModel.accessToken)"
            ]
            print("---------------------")
            print("URL: ", "\(urlPath)")
            print("HttpHeaders: ", "\(HttpHeaders)")
            print("Request: ", uploadDict ?? "")
            
            Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if uploadDict != nil{
                    for (key, value) in uploadDict! {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                if fileData != nil{
                    let count = fileData!.count
                    for i in 0...count - 1{
//                        print(fileData![i])
//                        print(paramName![i])
//                        print(fileName![i])
//                        print(mineType![i])
                        multipartFormData.append(fileData![i], withName:paramName![i], fileName: fileName![i], mimeType: mineType![i])
                    }
                }
                
                print("Multipart: ", "\(multipartFormData)")
                
                
            }, usingThreshold: UInt64.init(), to: urlPath, method: methods, headers: HttpHeaders) { (result) in
                switch result{
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                    })
                    upload.responseJSON { responseObject in
                        
                        print(responseObject.result)
                        let (status, statusCode, message, _) = handleError(response: responseObject)
                        if let resJson = responseObject.result.value as? NSDictionary{
                            print("Reponse: ", resJson)
                            print("StatusCode: ", statusCode)
                            print("---------------------")
                        }else{
                            print("StatusCode: ", statusCode)
                            print("---------------------")
                        }
                        if status == .Success{
                            completion(responseObject, message, statusCode, status)
                        }else{
                            
                            if statusCode == 401{
                                self.accessTokenModel = getAccessTokenModel()
                                self.unauthUrlPath = urlPath
                                self.unauthMethods = methods
                                self.unauthMultipath_ParamsName = paramName
                                self.unauthMultipath_File       = fileData
                                self.unauthMultipath_FileName   = fileName
                                self.unauthMultipath_MineType   = mineType
                                self.unauthMultipath_UploadDict = uploadDict

                                
                                let refreshToken = "\(self.accessTokenModel.refreshToken)"
                                let urlPath = kBaseURL + kAccessToken + "?grant_type=refresh_token&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&refresh_token=" + refreshToken
                                
                                self.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
                                    
                                    if statusCode == 200{
                                        do {
                                            let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())
                                            print(data.accessToken)
                                            setAccessTokenModel(model: data)
                                            
                                            self.multipartRequest(urlPath: self.unauthUrlPath, methods: self.unauthMethods, paramName: self.unauthMultipath_ParamsName, fileData: self.unauthMultipath_File, fileName: self.unauthMultipath_FileName, mineType: self.unauthMultipath_MineType, uploadDict: self.unauthMultipath_UploadDict) { (response, message, statusCode, status) in
                                                completion(response, message, statusCode, status)
                                            }
                                            
                                        } catch let error {
                                            print(error.localizedDescription)
                                            completion(response, "SOMETHING_WENT_WRONG".localized(), kSomethingWentWrongErrorCode, .Failure)
                                        }
                                    }else{
                                        completion(response, message, statusCode, status)
                                    }
                                }
                            }else{
                                completion(responseObject, message, statusCode, status)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }else{
            completion(nil , "INTERNET".localized(), kInternetErrorCode, .Failure)
        }
    }
    
    func stopRedirection(){
        let delegate = Alamofire.SessionManager.default.delegate
        delegate.taskWillPerformHTTPRedirection = { (_, _, _, _) -> URLRequest? in
            return nil
        }
    }
    
    func callRefreshTokenApi(completion:@escaping (_ response: DataResponse<Any>?, _ message: String?, _ statusCode: Int) -> Void){
        let refreshToken = ""
        let urlPath = kBaseURL + kAccessToken + "?grant_type=refresh_token&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&refresh_token=" + refreshToken
        
        self.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
            if (response?.result.isSuccess)!{
                
            }else{
                
            }
        }
    }
}
