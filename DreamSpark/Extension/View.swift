//
//  View.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import Foundation
import UIKit
import Toast_Swift

extension UIView {
    
    /*Set Corner for selected Edge*/
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func showToast(_ msg : String){
        self.makeToast(msg, duration: 2, position: .bottom)
    }
}

/** Extension to show Generic Message Alert Controller throughout the App **/
extension UIViewController{
    enum AlertTitle: String{
        case Success = "Success"
        case Error = "Error"
        case Alert = "Alert"
    }
    
    func showMessageAlert(title: String = "", message: String?, showRetry: Bool = true, retryTitle: String? = nil, showCancel: Bool = true, cancelTitle: String? = nil, onRetry: (() -> ())?, onCancel: (() -> ())?){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if showRetry{
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (retry) in
                    guard let onRetry = onRetry else{
                        return
                    }
                    onRetry()
                }))
            }
            if showCancel{
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
                    guard let onCancel = onCancel else{
                        return
                    }
                    onCancel()
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
