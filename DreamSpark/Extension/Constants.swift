//
//  Constants.swift
//  FirebaseAuthEx
//
//  Created by Maulik Bhuptani on 20/10/21.
//

import Foundation
import UIKit
import ZVProgressHUD
import SystemConfiguration

var USER_EMAIL: String? = ""
var USERS: String = "users"
var USER_ID: String? = ""
var PREMIUM_USER : Bool? = false

let BASE_URL = "http://apis.dreamsparkapp.com/api/"
let WEBURL = "https://dreamsparkapp.com/"

let PRIVACY_URL = "https://firebasestorage.googleapis.com/v0/b/dreamspark-6c27f.appspot.com/o/privacypolicy.docx?alt=media&token=196c5c03-ca95-4445-a88d-e22b5593ee44"
// API
let getDreamsAPI = "get-dream"
let postDreamsAPI = "upload-dream"
let postCommentAPI = "upload-comment"
let deleteDreamsAPI = "delete-dream"
let reportDreamsAPI = "report"
let deleteCommentAPI = "cmtdel"
let likeDreamAPI = "like-dream"

let TryAgain = "Please try again later"

let GREEN = UIColor(red: 46/255, green: 173/255, blue: 131/244, alpha: 1)
let BLUE = UIColor(red: 1/255, green: 22/255, blue: 87/244, alpha: 1)


/*Show API Loader*/
func showLoader(text : String = "Loading"){
    ZVProgressHUD.shared.show(with: text , delay: 0)
}

/*Hide API Loader*/
func hideLoader(){
    ZVProgressHUD.shared.dismiss()
}

/*Check Internet Connection*/
func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}
