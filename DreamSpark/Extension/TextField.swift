//
//  TextField.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 18/10/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBorder() {
        self.layer.borderColor = GREEN.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
    }
}

extension UITextView {
    
    func setBorder() {
        self.layer.borderColor = BLUE.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 8
    }
}
