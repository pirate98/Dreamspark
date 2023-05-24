//
//  DreamerViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 27/10/21.
//

import UIKit
import Firebase
import TPKeyboardAvoidingSwift

class DreamerAccountViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var follwerTextField : UITextField!
    @IBOutlet weak var nickNameTextField : UITextField!
    @IBOutlet weak var countryTextField : UITextField!
    @IBOutlet weak var descriptionTextView : UITextView!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var backButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.setBorder()
        follwerTextField.setBorder()
        nickNameTextField.setBorder()
        countryTextField.setBorder()
        backButton.setBorder()
        descriptionTextView.setBorder()
        
        follwerTextField.textColor = GREEN
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
