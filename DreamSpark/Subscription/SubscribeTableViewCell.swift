//
//  SubscribeTableViewCell.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class SubscribeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var amountLable : UILabel!
    @IBOutlet weak var daysLable : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        amountLable.layer.cornerRadius = 8
        outerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        outerView.layer.borderColor = BLUE.cgColor
        outerView.layer.borderWidth = 2
//        outerView.layer.addBorder(edge: .top, color: BLUE, thickness: 2)
//        outerView.layer.addBorder(edge: .right, color: BLUE, thickness: 2)
//        outerView.layer.addBorder(edge: .left, color: BLUE, thickness: 2)
    }
}

