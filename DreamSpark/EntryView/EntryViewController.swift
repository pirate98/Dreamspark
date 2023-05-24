//
//  EntryViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var mainTableView : UITableView!
    @IBOutlet weak var signOutButton : UIButton!
    @IBOutlet weak var descriptionButton : UIButton!
    
    let titleArray : [String] = ["MY ACCOUNT", "MAIN PAGE", "MY PREMIUM DREAMS", "DREAMERS FOLLOWED", "DREAMSPARK"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerNib()
        signOutButton.setBorder()
        descriptionButton.setBorder()
    }
    
    /* Register Cell */
    func registerNib(){
        self.mainTableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTableViewCell")
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.reloadData()
    }
    
    /*Load site Action*/
    @IBAction func `webViewAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = WEBURL
        self.present(viewController, animated: true, completion: nil)
    }
    
    /*SignOut Action*/
    @IBAction func `signOutAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*description Action*/
    @IBAction func `descriptionAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDescriptionViewController") as! UserDescriptionViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*Load site Action*/
    @IBAction func `privacyAction`(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.webURLString = PRIVACY_URL
        self.present(viewController, animated: true, completion: nil)
    }
}

extension EntryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
        cell.titleLable.text = titleArray[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.row == 0 || indexPath.row + 1 == titleArray.count{
            cell.titleLable.textColor = BLUE
            cell.topView.backgroundColor = BLUE
        }else{
            cell.titleLable.textColor = GREEN
            cell.topView.backgroundColor = GREEN
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 1{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DreamsListViewController") as! DreamsListViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 2{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SubcribeViewController") as! SubcribeViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 3{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowedViewController") as! UserFollowedViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DreamSparkViewController") as! DreamSparkViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
