//
//  String.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 16/10/21.
//

import Foundation
import UIKit

extension String {
    
    /*Check Empty String*/
    var isEmptyStr: Bool{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    /*Check Empty String*/
    var trim: String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /*Validate Email*/
    func isValidEmail() -> Bool {
        //        RFC 5322 Standard Email Validation
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

