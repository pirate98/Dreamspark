//
//  DreamsListViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit
import TPKeyboardAvoidingSwift
import ObjectMapper
import Alamofire
import AppLovinSDK


class DreamsListViewController: UIViewController {
    
    var rewardedAd: MARewardedAd!
    var retryAttempt = 0.0
    let refreshControl = UIRefreshControl()
    var permiumUserFlag : Bool? = false
    
    @IBOutlet weak var dreamsTableView : TPKeyboardAvoidingTableView!
    @IBOutlet weak var premiumBannerHeight : NSLayoutConstraint!
    @IBOutlet weak var backButton : UIButton!
    
    @IBOutlet weak var footerView : UIView!
    @IBOutlet weak var textView : UIView!
    @IBOutlet weak var premiumButton : UIButton!
    @IBOutlet weak var sendButton : UIButton!
    @IBOutlet weak var footerViewHeight : NSLayoutConstraint!
    @IBOutlet weak var dreamTextField : UITextField!
    @IBOutlet weak var lengthLable : UILabel!
    
    @IBOutlet weak var changeTextLabel : UILabel!
    @IBOutlet weak var footerBottomLabel : UILabel!
    @IBOutlet weak var iDreamLabel : UILabel!
    @IBOutlet weak var iDreamLabelWidth : NSLayoutConstraint!
    
    
    var dreamList : [DreamDataList]?
    var dreamType : DreamType = .GENERAL
    var commentPostFlag : Bool = false
    var commentPostUUID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerCell()
        backButton.setBorder()
        sendButton.setBorder(bgColor: GREEN)
        premiumButton.setBorder(bgColor: GREEN)
        dreamTextField.delegate = self
        textView.layer.cornerRadius = 5
        createRewardedAd()
        
        switch self.dreamType {
        case .GENERAL:
            premiumBannerHeight.constant = 0
            footerViewHeight.constant = 130
        case .PREMEIUM :
            premiumBannerHeight.constant = 30
            footerViewHeight.constant = 130
        case .PREMEIUMLIST :
            premiumBannerHeight.constant = 30
            footerViewHeight.constant = 0
        }
        self.getDreamsListAPI()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        dreamsTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGradientBackground()
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [BLUE.cgColor, GREEN.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.footerView.bounds
        self.footerView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func `premiumAction`(_ sender: UIButton) {
        self.showSubscriptionPage()
    }
    
    func showSubscriptionPage(){
        self.view.endEditing(true)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SubcribeViewController") as! SubcribeViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getDreamsListAPI()
    }
    
    func createRewardedAd(){
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "YOUR_AD_UNIT_ID")
        rewardedAd.delegate = self
        // Load the first ad
        rewardedAd.load()
    }
    
    func registerCell() {
        dreamsTableView.delegate = self
        dreamsTableView.dataSource = self
        dreamsTableView.register(UINib(nibName: "CommentaryTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentaryTableViewCell")
        dreamsTableView.register(UINib(nibName: "DreamListTableViewCell", bundle: nil), forCellReuseIdentifier: "DreamListTableViewCell")
    }
    
    func getDreamsListAPI(){
        showLoader()
        let params : Parameters = ["device_token": USER_ID ?? ""]
        WebService.shared.callAPI(type: DreamListModel.self, with: getDreamsAPI, method: .post, parameter: params, completion: { (response, error, code) in
            hideLoader()
            self.refreshControl.endRefreshing()
            if code == 200{
                self.dreamList = response?.data
                self.dreamsTableView.reloadData()
            }else {
                self.view.showToast(error ?? TryAgain)
            }
        })
    }
    
    /*Back Action*/
    @IBAction func `backAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*Back Action*/
    @IBAction func `postDreamAction`(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let text = self.dreamTextField.text, !text.isEmptyStr else{
            self.view.showToast("Enter the text to post")
            return
        }
        
        if self.commentPostFlag{
            self.showMessageAlert(message: "Confirm the publication of this commentary") {
                if self.rewardedAd.isReady{
                    self.rewardedAd.show()
                }
            } onCancel: {
                // User cancelled
            }
        }else{
            self.showMessageAlert(message: "Confirm the publication of this dream") {
                if PREMIUM_USER == false {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SubcribeViewController") as! SubcribeViewController
                    viewController.premiumDreamClosure = { flag in
                        self.postDream()
                    }
                    self.present(viewController, animated: true, completion: nil)
                }else{
                    self.postDream()
                }
            } onCancel: {
                // User cancelled
            }
        }
    }
    
    func postDream(){
        guard let text = self.dreamTextField.text, !text.isEmptyStr else{
            self.view.showToast("Enter the text to post")
            return
        }
        showLoader()
        let params : Parameters = ["device_token": USER_ID ?? "", "description" : text, "title" : "title"]
        WebService.shared.callAPI(type: DreamUploadModel.self, with: postDreamsAPI, method: .post, parameter: params, completion: { (response, error, code) in
            hideLoader()
            if code == 200{
                if response?.success == true{
                    self.dreamTextField.text = ""
                    self.lengthLable.text = "0/320"
                    self.iDreamLabelWidth.constant = 50
                    self.iDreamLabel.isHidden = false
                    self.getDreamsListAPI()
                    self.view.showToast("Your dream is now online for 1 day")
                }else{
                    self.view.showToast(response?.message ?? TryAgain)
                }
            }else {
                self.view.showToast(error ?? TryAgain)
            }
        })
    }
}

extension DreamsListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dreamList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !(dreamList?[section].collapsed ?? false) ? 0 : dreamList?[section].dreams_comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentaryTableViewCell", for: indexPath) as! CommentaryTableViewCell
        cell.selectionStyle = .none
        let comment = dreamList?[indexPath.section].dreams_comments?[indexPath.row]
        cell.dreamCommnets = comment
        cell.commentaryLabel.text = comment?.comment
        if (dreamList?[indexPath.section].dreams_comments?.count ?? 0) == 1 {
            cell.bgView.layer.cornerRadius = 5
        }else {
            if indexPath.row == 0 {
                cell.bgView.roundCorners(corners: [.topRight, .topLeft], radius: 5)
            }else if indexPath.row + 1 == (dreamList?[indexPath.section].dreams_comments?.count ?? 0){
                cell.bgView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 5)
            }
            cell.layoutIfNeeded()
        }
        cell.dreamUUIDClosure = { (dreamCommentSection) in
            var msg = "Confirm the deletion of this comment the user will no longer be able to comment on this dream"
            if dreamCommentSection?.device_token == USER_ID {
                msg = "Confirm the deletion of this comment"
            }
            self.showMessageAlert(message: msg) {
                self.deleteComment(uuid: dreamCommentSection?.uuid)
            } onCancel: {
                // User Cancelled
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DreamListTableViewCell") as! DreamListTableViewCell
        switch self.dreamType {
        case .GENERAL:
            cell.daysView.isHidden = true
            cell.premiumOuterView.isHidden = true
        case .PREMEIUM :
            break
        case .PREMEIUMLIST :
            break
        }
        if dreamList?[section].dreams_comments?.count ?? 0 > 0 {
            cell.outerView.backgroundColor = BLUE
        }else if dreamList?[section].device_token == USER_ID{
            cell.outerView.backgroundColor = GREEN
        }else{
//            cell.outerView.backgroundColor = .white
//            cell.innerView.layer.borderColor = UIColor.lightGray.cgColor
//            cell.innerView.layer.borderWidth = 0.5
            cell.outerView.backgroundColor = GREEN
        }
        cell.dreamLabel.text = dreamList?[section].description
        cell.commentryCountLabel.text = "\(dreamList?[section].dreams_comments?.count ?? 0)"
        cell.startCountLabel.text = "\(dreamList?[section].dreams_likes ?? 0)"
        cell.commentryButton.tag = section
        cell.reportButton.tag = section
        cell.deleteButton.tag = section
        cell.starButton.tag = section
        cell.starButton.backgroundColor = dreamList?[section].isLike ?? 0 == 0 ? GREEN : BLUE
        cell.selectionStyle = .none
        cell.commentryButton.addTarget(self, action: #selector(self.expandCollapse(_:)), for: .touchUpInside)
        cell.reportButton.addTarget(self, action: #selector(self.reportButton(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButton(_:)), for: .touchUpInside)
        cell.starButton.addTarget(self, action: #selector(self.starButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // expandCollapse action to get section and row
    @objc func expandCollapse(_ sender : UIButton!){
        let section = sender.tag
        if let collapsed = dreamList?[section].collapsed {
            dreamList?[section].collapsed = !collapsed
            if collapsed {
                self.commentPostFlag = false
                footerBottomLabel.text = "WRITE AND SHARE YOUR DREAM WITH THE WORLD"
                changeTextLabel.text = "Dream length"
                dreamTextField.placeholder = "Write your dream"
                premiumButton.isHidden = false
                iDreamLabelWidth.constant = 50
                iDreamLabel.isHidden = false
            }else{
                self.commentPostFlag = true
                footerBottomLabel.text = "WRITE A COMMENT TO THE SELECTED DREAM"
                changeTextLabel.text = "Comment length"
                dreamTextField.placeholder = "Write your comment"
                premiumButton.isHidden = true
                iDreamLabelWidth.constant = 0
                iDreamLabel.isHidden = true
            }
        }
        self.lengthLable.text = "0/320"
        self.dreamTextField.text = ""
        self.commentPostUUID = dreamList?[section].uuid
        self.dreamsTableView.reloadData()
    }
    
    @objc func deleteButton(_ sender : UIButton!){
        self.showMessageAlert(message: "Confirm the deletion of this dream") {
            let section = sender.tag
            showLoader()
            let params : Parameters = ["device_token": USER_ID ?? "", "dream_uuid" : self.dreamList?[section].uuid ?? ""]
            WebService.shared.callAPI(type: DreamUploadModel.self, with: deleteDreamsAPI, method: .post, parameter: params, completion: { (response, error, code) in
                hideLoader()
                if code == 200{
                    if response?.success == true{
                        self.dreamTextField.text = ""
                        self.getDreamsListAPI()
                        self.view.showToast(response?.message ?? "")
                    }else{
                        self.view.showToast(response?.message ?? TryAgain)
                    }
                }else {
                    self.view.showToast(error ?? TryAgain)
                }
            })
        } onCancel: {
            //User Cancelled
        }
    }
    
    @objc func starButton(_ sender : UIButton!){
        let section = sender.tag
        showLoader()
        let params : Parameters = ["device_token": USER_ID ?? "", "dream_uuid" : dreamList?[section].uuid ?? "", "is_like" : dreamList?[section].isLike ?? 0 == 0 ? 1 : 0]
        WebService.shared.callAPI(type: DreamUploadModel.self, with: likeDreamAPI, method: .post, parameter: params, completion: { (response, error, code) in
            hideLoader()
            if code == 200{
                if response?.success == true{
                    self.dreamTextField.text = ""
                    self.getDreamsListAPI()
                    self.view.showToast(response?.message ?? "")
                }else{
                    self.view.showToast(response?.message ?? TryAgain)
                }
            }else {
                self.view.showToast(error ?? TryAgain)
            }
        })
    }
    
    @objc func reportButton(_ sender : UIButton!){
        self.showMessageAlert(message: "Confirm this dream as inappropriate") {
            let section = sender.tag
            showLoader()
            let params : Parameters = ["device_token": USER_ID ?? "", "dream_uuid" : self.dreamList?[section].uuid ?? ""]
            WebService.shared.callAPI(type: DreamUploadModel.self, with: reportDreamsAPI, method: .post, parameter: params, completion: { (response, error, code) in
                hideLoader()
                if code == 200{
                    if response?.success == true{
                        self.dreamTextField.text = ""
                        self.getDreamsListAPI()
                        self.view.showToast(response?.message ?? "")
                    }else{
                        self.view.showToast(response?.message ?? TryAgain)
                    }
                }else {
                    self.view.showToast(error ?? TryAgain)
                }
            })
        } onCancel: {
            //User Cancelled
        }
    }
    
    func deleteComment(uuid: String?){
        showLoader()
        let params : Parameters = ["device_token": USER_ID ?? "", "comment_uuid" : uuid ?? ""]
        WebService.shared.callAPI(type: DreamUploadModel.self, with: deleteCommentAPI, method: .post, parameter: params, completion: { (response, error, code) in
            hideLoader()
            if code == 200{
                if response?.success == true{
                    self.getDreamsListAPI()
                    self.view.showToast(response?.message ?? "")
                }else{
                    self.view.showToast(response?.message ?? TryAgain)
                }
            }else {
                self.view.showToast(error ?? TryAgain)
            }
        })
    }
}

extension DreamsListViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 320
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        lengthLable.text = "\(newString.length)/320"
        return newString.length < maxLength
    }
}


extension DreamsListViewController: MAAdDelegate, MARewardedAdDelegate {
    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd)
    {
        // Rewarded ad is ready to be shown. '[self.rewardedAd isReady]' will now return 'YES'
        
        // Reset retry attempt
        retryAttempt = 0
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError)
    {
        // Rewarded ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.rewardedAd.load()
        }
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd)
    {
        // Rewarded ad is hidden. Pre-load the next ad
        rewardedAd.load()
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError)
    {
        // Rewarded ad failed to display. We recommend loading the next ad
        rewardedAd.load()
    }
    
    // MARK: MARewardedAdDelegate Protocol
    
    func didStartRewardedVideo(for ad: MAAd) {
        
    }
    
    func didCompleteRewardedVideo(for ad: MAAd) {
        
    }
    
    func didRewardUser(for ad: MAAd, with reward: MAReward)
    {
        guard let text = self.dreamTextField.text, !text.isEmptyStr else{
            self.view.showToast("Enter the text to post")
            return
        }
        guard let uuid = self.commentPostUUID else{
            self.view.showToast("Dream not found")
            return
        }
        // Rewarded ad was displayed and user should receive the reward
        showLoader()
        let params : Parameters = ["device_token": USER_ID ?? "", "comment" : text, "dream_uuid" : uuid]
        WebService.shared.callAPI(type: DreamUploadModel.self, with: postCommentAPI, method: .post, parameter: params, completion: { (response, error, code) in
            hideLoader()
            if code == 200{
                if response?.success == true{
                    self.commentPostUUID = ""
                    self.dreamTextField.text = ""
                    self.lengthLable.text = "0/320"
                    self.getDreamsListAPI()
                    self.view.showToast(response?.message ?? "")
                }else{
                    self.view.showToast(response?.message ?? TryAgain)
                }
            }else {
                self.view.showToast(error ?? TryAgain)
            }
        })
    }
}

