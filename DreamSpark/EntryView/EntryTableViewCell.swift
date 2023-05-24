//
//  EntryTableViewCell.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var titleLable : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.topView.layer.cornerRadius = 15
        self.bottomView.layer.cornerRadius = 10
    }
}
