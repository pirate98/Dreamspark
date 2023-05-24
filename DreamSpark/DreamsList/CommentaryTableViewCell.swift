//
//  CommentaryTableViewCell.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import UIKit

class CommentaryTableViewCell: UITableViewCell {

    @IBOutlet weak var commentaryLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var dreamCommnets : DreamCommentList?
    var dreamUUIDClosure:((DreamCommentList?)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 5.0
        self.setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.5
        longPressGesture.delegate = self
        self.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            print("comment long pressed")
            dreamUUIDClosure?(dreamCommnets)
        }
    }
}
