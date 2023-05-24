//
//  RegisterViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 16/10/21.
//

import UIKit
import TPKeyboardAvoidingSwift
import CountryPickerView
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var nickNameTextField : UITextField!
    @IBOutlet weak var confirmPasswordTextField : UITextField!
    @IBOutlet weak var countryTextField : UITextField!
    @IBOutlet weak var dropDownImage : UIImageView!
    
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var signUpButton : UIButton!
    
    let countryPickerView = CountryPickerView()
    var countryDetials : Country?
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nickNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        countryPickerView.delegate = self
        countryTextField.delegate = self
        
        emailTextField.setBorder()
        passwordTextField.setBorder()
        nickNameTextField.setBorder()
        confirmPasswordTextField.setBorder()
        countryTextField.setBorder()
        
        backButton.setBorder()
        signUpButton.setBorder()
        dropDownImage.backgroundColor = GREEN
        
        backButton.backgroundColor = BLUE
        signUpButton.backgroundColor = BLUE
        dropDownImage.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
    }
    
    /*SignUp Action*/
    @IBAction func `SignUpAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        if let name = self.nickNameTextField.text, name.isEmptyStr{
            self.view.showToast("Enter nick name")
        }else if let email = self.emailTextField.text?.trim{
            if email.isEmptyStr{
                self.view.showToast("Enter email address")
            }else if email.isValidEmail() == false{
                self.view.showToast("Enter valid email address")
            }else if let password = self.passwordTextField.text{
                if password.isEmptyStr{
                    self.view.showToast("Enter password")
                }else if password.count < 8 {
                    self.view.showToast("Password should be minimum of 8 characters long")
                }else if password != self.confirmPasswordTextField.text{
                    self.view.showToast("Password and confirm password doesn't match")
                }else if let ctry = self.countryTextField.text, ctry.isEmptyStr{
                    self.view.showToast("Please select the country")
                }else{
                    showLoader()
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        hideLoader()
                        if let error = error {
                            self.view.showToast(error.localizedDescription)
                        }else{
                            if let uid = Auth.auth().currentUser?.uid{
                                USER_EMAIL = self.emailTextField.text?.trim
                                USER_ID = Auth.auth().currentUser?.uid
                                self.ref.child(USERS).child(uid).setValue(["nickname": self.nickNameTextField.text ?? "", "country": self.countryTextField.text ?? "", "showEmail" : true])
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    }

                }
            }
        }
    }
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nickNameTextField {
            self.emailTextField.becomeFirstResponder()
        }else if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            self.passwordTextField.resignFirstResponder()
        }else{
            self.confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTextField {
            countryPickerView.showCountriesList(from: self)
            return false
        }else{
            return true
        }
    }
}

extension RegisterViewController : CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.view.endEditing(true)
        countryDetials = country
        countryTextField.text = country.name
    }
}
