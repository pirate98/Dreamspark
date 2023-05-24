//
//  UserDescriptionViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 26/10/21.
//

import UIKit
import Firebase
import TPKeyboardAvoidingSwift

class UserDescriptionViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var descriptionTextView : UITextView!
   
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var submitButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        descriptionTextView.delegate = self
        descriptionTextView.setBorder()
        backButton.setBorder()
        submitButton.setBorder(bgColor: GREEN)
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
    
    /*submit Action*/
    @IBAction func `SubmitAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        if let description = self.descriptionTextView.text, description.isEmptyStr{
            self.view.showToast("Enter your description")
        }else{
            
        }
    }
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserDescriptionViewController : UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 750
    }
}
