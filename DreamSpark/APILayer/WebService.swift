//
//  WebService.swift
//  VisaDigital_iOS
//
//  Created by sidhudevarayan on 23/07/20.
//  Copyright © 2020 sidhudevarayan. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper

class WebService: NSObject {
    static let shared = WebService()
    
    func callAPI<T: Mappable>(type: T.Type,
                              with api:String,
                              method: HTTPMethod,
                              parameter: Parameters?,
                              completion: @escaping  (_ result: T?,_ error:String?, _ code: Int) -> Void)  {
        
        if isInternetAvailable() {
            var param: Parameters = [:]
            var urlString = BASE_URL + api
            if method == .get {
                if parameter != nil {
                    var postString = ""
                    for (key,value) in parameter ?? [:] {
                        postString += key + "=" + "\(value)" + "&"
                    }
                    if postString.hasSuffix("&") {
                        postString.removeLast()
                    }
                    urlString = urlString + "?" + postString
                }
            }else{
                param = parameter ?? [:]
            }
            print(parameter ?? [:])
            print(urlString)
            
            AF.request(urlString, method: method, parameters: param,encoding: JSONEncoding.default, headers: nil)
                .responseJSON { (response) in
                    let code = response.response?.statusCode
                    switch response.result {
                    case .success(let json) :
                        print("====== Response ====== \n \(json)")
                        let request = Mapper<T>().map(JSONObject: json)
                        completion(request,nil,code ?? 0)
                        break
                    case .failure(let error):
                        print(error)
                        let error = error.localizedDescription
                        if error == "Unauthenticated." {
                            return
                        }
                        completion(nil,error,code ?? 0)
                    }
            }
        }else{
            // No internet page
        }
    }
}
