//
//  DreamSparkViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 18/10/21.
//

import UIKit
import TPKeyboardAvoidingSwift
import HCSStarRatingView

class DreamSparkViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var totalPostTextField : UITextField!
    @IBOutlet weak var singleUserStarTextField : UITextField!
    @IBOutlet weak var userPostTextField : UITextField!
    @IBOutlet weak var ratingView : HCSStarRatingView!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var shareButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        totalPostTextField.setBorder()
        backButton.setBorder()
        shareButton.setBorder()
        totalPostTextField.textColor = GREEN
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
    
    /*Load site Action*/
    @IBAction func `privacyAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = PRIVACY_URL
        self.present(viewController, animated: true, completion: nil)
    }
}
