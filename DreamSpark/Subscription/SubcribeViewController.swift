//
//  SubcribeViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class SubcribeViewController: UIViewController {
    @IBOutlet weak var mainTableView : UITableView!
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var innerView : UIView!
    @IBOutlet weak var postDreamButton : UIButton!
    @IBOutlet weak var bottomLabel : UILabel!
    
    var subscribeArrayValue = [SubscribeModel]()
    var premiumDreamClosure:((Bool?)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeArrayValue.append(SubscribeModel(amount: "7.90 $", days: "30 DAYS"))
        subscribeArrayValue.append(SubscribeModel(amount: "5.90 $", days: "15 DAYS"))
        subscribeArrayValue.append(SubscribeModel(amount: "3.90 $", days: "7 DAYS"))
        
        // Do any additional setup after loading the view.
        self.outerView.layer.cornerRadius = 12
        self.innerView.layer.cornerRadius = 8
        self.registerNib()
        
        postDreamButton.setBorder(bgColor: GREEN)
        bottomLabel.backgroundColor = BLUE
    }
    
    /* Register Cell */
    func registerNib(){
        self.mainTableView.register(UINib(nibName: "SubscribeTableViewCell", bundle: nil), forCellReuseIdentifier: "SubscribeTableViewCell")
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.reloadData()
    }
    
    /*SignOut Action*/
    @IBAction func `withOutDreamAction`(_ sender: UIButton) {
        if (self.presentingViewController != nil){
            self.premiumDreamClosure?(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DreamsListViewController") as! DreamsListViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SubcribeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeArrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "SubscribeTableViewCell") as! SubscribeTableViewCell
        cell.selectionStyle = .none
        cell.amountLable.text = subscribeArrayValue[indexPath.row].amount
        cell.daysLable.text = subscribeArrayValue[indexPath.row].days
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

struct SubscribeModel {
    var amount : String?
    var days : String?
    
    public init(amount : String, days : String){
        self.amount = amount
        self.days = days
    }
}
