//
//  AccountViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 18/10/21.
//

import UIKit
import TPKeyboardAvoidingSwift
import CountryPickerView
import Firebase
import FirebaseDatabase

class AccountViewController: UIViewController {

    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var nickNameTextField : UITextField!
    @IBOutlet weak var confirmPasswordTextField : UITextField!
    @IBOutlet weak var countryTextField : UITextField!
    @IBOutlet weak var dreamsFollowedTextField : UITextField!
    
    @IBOutlet weak var dreamsTextField : UITextField!
    let countryPickerView = CountryPickerView()
    var countryDetials : Country?
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var dontShowButton : UIButton!
    @IBOutlet weak var learnMoreButton : UIButton!
    @IBOutlet weak var dropDownImage : UIImageView!
    @IBOutlet weak var starImage : UIView!
    var showEmail : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nickNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        countryPickerView.delegate = self
        countryTextField.delegate = self
        dreamsFollowedTextField.delegate = self
        
        emailTextField.setBorder()
        passwordTextField.setBorder()
        nickNameTextField.setBorder()
        confirmPasswordTextField.setBorder()
        countryTextField.setBorder()
        dreamsTextField.setBorder()
        dreamsFollowedTextField.setBorder()
        
        dreamsTextField.textColor = GREEN
        dreamsFollowedTextField.textColor = GREEN
        
        self.readCurrentUserDetail()
        
        submitButton.setBorder()
        backButton.setBorder()
        dontShowButton.setBorder()
        learnMoreButton.setBorder(bgColor : GREEN)
        
        dropDownImage.backgroundColor = GREEN
        starImage.backgroundColor = GREEN
        dropDownImage.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        starImage.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
    }
    
    func readCurrentUserDetail(){
        showLoader()
        if let user = Auth.auth().currentUser {
            ref.child(USERS).child(user.uid).getData { (error, snapshot) in
                hideLoader()
                if let error = error {
                    self.view.showToast(error.localizedDescription)
                }
                else if snapshot.exists() {
                    print("Got data \(snapshot.value!)")
                    if let userDict = snapshot.value as? Dictionary<String, Any> {
                        self.nickNameTextField.text = userDict["nickname"] as? String
                        self.countryTextField.text = userDict["country"] as? String
                        self.showEmail = userDict["showEmail"] as? Bool
                        if self.showEmail == true{
                            self.dontShowButton.setTitle("Do not show", for: .normal)
                            self.dontShowButton.backgroundColor = BLUE
                        }else{
                            self.dontShowButton.setTitle("Show Email", for: .normal)
                            self.dontShowButton.backgroundColor = GREEN
                        }
                        self.emailTextField.text = USER_EMAIL
                    }
                }
                else {
                    self.view.showToast("No data available")
                }
            }
        }
    }
    
    /*SignUp Action*/
    @IBAction func `SubmitAction`(_ sender: UIButton) {
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
                    self.view.showToast("Enter new password")
                }else if password.count < 8 {
                    self.view.showToast("Password should be minimum of 8 characters long")
                }else if password != self.confirmPasswordTextField.text{
                    self.view.showToast("New password and confirm new password doesn't match")
                }else{
                    self.updateRealTimeDatabase()
                }
            }
        }
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
    
    func updateRealTimeDatabase(){
        showLoader()
        if let uid = USER_ID {
            ref.child(USERS).child(uid).observeSingleEvent(of: .value, with: { snapshot in
                hideLoader()
                if !snapshot.exists(){
                    if let uid = Auth.auth().currentUser?.uid{
                        USER_EMAIL = self.emailTextField.text?.trim
                        USER_ID = Auth.auth().currentUser?.uid
                        self.ref.child(USERS).child(uid).setValue(["nickname": self.nickNameTextField.text ?? "", "country": self.countryTextField.text ?? "", "showEmail" : self.showEmail ?? true])
                    }
                }else{
                    self.ref.child(USERS).child(uid).updateChildValues(["nickname": self.nickNameTextField.text ?? "", "country": self.countryTextField.text ?? "", "showEmail" : self.showEmail ?? true] as Dictionary<String,Any>)
                    self.updateEmail()
                    self.updatePassword()
                }
            })
        }
    }
    
    func updatePassword(){
        showLoader()
        Auth.auth().currentUser?.updatePassword(to: self.passwordTextField.text ?? "") { error in
            hideLoader()
            if let error = error {
                self.view.showToast(error.localizedDescription)
            }else{
                self.passwordTextField.text = ""
                self.confirmPasswordTextField.text = ""
                self.view.showToast("Updated successfully.")
            }
        }
    }
    
    func updateEmail(){
        if let email = USER_EMAIL, email != self.emailTextField.text?.trim {
            showLoader()
            Auth.auth().currentUser?.updateEmail(to: self.emailTextField.text?.trim ?? "") { error in
                hideLoader()
                if let error = error {
                    self.view.showToast(error.localizedDescription)
                }else{
                    USER_EMAIL = self.emailTextField.text?.trim
                    self.view.showToast("Updated successfully.")
                }
            }
        }
    }
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*Back Action*/
    @IBAction func `dontShowNickNameAction`(_ sender: UIButton) {
        self.showEmail = !(self.showEmail ?? true)
        if self.showEmail == true{
            self.dontShowButton.setTitle("Do not show", for: .normal)
            self.dontShowButton.backgroundColor = BLUE
        }else{
            self.dontShowButton.setTitle("Show Email", for: .normal)
            self.dontShowButton.backgroundColor = GREEN
        }
        if let userID = USER_ID {
            ref.child(USERS).child(userID).child("showEmail").setValue(self.showEmail!)
        }
    }
    
    /*Back Action*/
    @IBAction func `learnMoreAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DreamerAccountViewController") as! DreamerAccountViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AccountViewController : UITextFieldDelegate {
    
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

extension AccountViewController : CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.view.endEditing(true)
        countryDetials = country
        countryTextField.text = country.name
    }
}
