//
//  UserFollowedViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 26/10/21.
//

import UIKit
import Firebase
import TPKeyboardAvoidingSwift

class UserFollowedViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var follwerTableView : UITableView!
   
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var backButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.setBorder()
        registerNib()
    }
    
    /* Register Cell */
    func registerNib(){
        self.follwerTableView.register(UINib(nibName: "FollowersTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowersTableViewCell")
        self.follwerTableView.delegate = self
        self.follwerTableView.dataSource = self
        self.follwerTableView.reloadData()
    }
    
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserFollowedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.follwerTableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell") as! FollowersTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

