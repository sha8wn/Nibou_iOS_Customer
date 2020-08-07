
import UIKit
import Foundation
import Alamofire

func handleError(response: DataResponse<Any>?) -> (WebServiceResponseType, Int, String, DataResponse<Any>?)
{
    if response?.response == nil {
        return (.Failure, kSomethingWentWrongErrorCode, "SOMETHING_WENT_WRONG".localized(), response)
    }else{
        if response!.result.isSuccess{
            if response?.response?.statusCode == 200{
                return (.Success, response!.response!.statusCode, "SUCCESS".localized(), response)
            }else if response?.response?.statusCode == 201{
                return (.Success, response!.response!.statusCode, "SUCCESS".localized(), response)
            }else{
                let responseDict = response!.result.value as! NSDictionary
                if let error = responseDict.value(forKey: "error") as? String{
                    return (.Failure, response!.response!.statusCode, "\(error)", response)
                }else if let error = responseDict.value(forKey: "errors") as? NSArray{
                    if let errorDict = error[0] as? NSDictionary{
                        if let errorDesc = errorDict.value(forKey: "detail") as? String{
                            return (.Failure, response!.response!.statusCode, errorDesc, response)
                        }else{
                            return (.Failure, response!.response!.statusCode, "SOMETHING_WENT_WRONG".localized(), response)
                        }
                    }else{
                        return (.Failure, response!.response!.statusCode, "SOMETHING_WENT_WRONG".localized(), response)
                    }
                }else{
                    return (.Failure, response!.response!.statusCode, "SOMETHING_WENT_WRONG".localized(), response)
                }
            }
        }else if response!.result.isFailure{
            return (.Failure, kServerTimeOut, "SERVER_TIME_OUT".localized(), response)
        }else{
            return (.Failure, kSomethingWentWrongErrorCode, "SOMETHING_WENT_WRONG".localized(), response)
        }
    }
}
