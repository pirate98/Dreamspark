//
//  DreamListTableViewCell.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class DreamListTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var dreamLabel: UILabel!
    @IBOutlet weak var whoseDreamLabel: UILabel!
    @IBOutlet weak var remainigDaysLabel: UILabel!
    @IBOutlet weak var startCountLabel: UILabel!
    @IBOutlet weak var commentryCountLabel: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var commentryButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var premiumOuterView : UIView!
    @IBOutlet weak var premiumInnerView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        innerView.layer.cornerRadius = 8
        outerView.layer.cornerRadius = 8
        startCountLabel.layer.cornerRadius = 5
        commentryCountLabel.layer.cornerRadius = 5
        commentryCountLabel.layer.borderWidth = 2
        commentryCountLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        reportButton.layer.borderWidth = 1.5
        reportButton.layer.borderColor = UIColor.red.cgColor
        reportButton.layer.cornerRadius = 5
        
        self.premiumOuterView.layer.cornerRadius = 6
        self.premiumInnerView.layer.cornerRadius = 4
        
        commentryButton.setBorder()
        starButton.setBorder(bgColor: GREEN)
        startCountLabel.backgroundColor = GREEN
    }
}
