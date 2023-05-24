//
//  FollowersTableViewCell.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 26/10/21.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {

    @IBOutlet weak var nickName : UILabel!
    @IBOutlet weak var learnMoreButton : UIButton!
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var iconImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 10
        outerView.layer.borderColor = BLUE.cgColor
        outerView.layer.borderWidth = 3
        
        learnMoreButton.setBorder(bgColor: GREEN)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
