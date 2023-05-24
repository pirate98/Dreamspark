//
//  ViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 16/10/21.
//

import UIKit
import TPKeyboardAvoidingSwift
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var resetEmailTextField : UITextField!
    
    @IBOutlet weak var registerButton : UIButton!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var resetButton : UIButton!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        resetEmailTextField.delegate = self
        
        emailTextField.setBorder()
        passwordTextField.setBorder()
        resetEmailTextField.setBorder()
        
        registerButton.backgroundColor = GREEN
        loginButton.backgroundColor = BLUE
        resetButton.backgroundColor = BLUE
        
        emailTextField.text = "my.iosfactory@gmail.com"
        passwordTextField.text = "iosfactory@123$"
        
        loginButton.setBorder()
        registerButton.setBorder(bgColor: GREEN)
        resetButton.setBorder()
    }
    
    /*Login Action*/
    @IBAction func `loginAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        if let email = self.emailTextField.text?.trim{
            if email.isEmptyStr{
                self.view.showToast("Enter email address")
            }else if email.isValidEmail() == false{
                self.view.showToast("Enter valid email address")
            }else if let password = self.passwordTextField.text{
                if password.isEmptyStr{
                    self.view.showToast("Enter password")
                }else if password.count < 8 {
                    self.view.showToast("Password should be minimum of 8 characters long")
                }else{
                    showLoader()
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        hideLoader()
                        if let error = error {
                            self.view.showToast(error.localizedDescription)
                        }else{
                            USER_EMAIL = self.emailTextField.text?.trim
                            USER_ID = Auth.auth().currentUser?.uid
                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    /*Reset Action*/
    @IBAction func `resetAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        if let email = self.resetEmailTextField.text{
            if email.isEmptyStr{
                self.view.showToast("Enter email address to reset password")
            }else if email.isValidEmail() == false{
                self.view.showToast("Enter valid email address")
            }else{
                showLoader()
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    hideLoader()
                    if let error = error {
                        self.view.showToast(error.localizedDescription)
                    }else{
                        self.view.showToast("You'll get a password reset link if your email id exists in the database.")
                    }
                }
            }
        }
    }
    
    /*Register Action*/
    @IBAction func `registerAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            self.passwordTextField.resignFirstResponder()
        }else{
            self.resetEmailTextField.resignFirstResponder()
        }
        return true
    }
}

