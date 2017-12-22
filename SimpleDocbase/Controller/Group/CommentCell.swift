//
//  CommentCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class CommentCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else {
                return
            }
            guard let user = comment.user else {
                return
            }
            
            let imageURL = URL(string: user.profile_image_url)
            let imageURLData = try? Data(contentsOf: imageURL!)
            profileImageView.image = UIImage(data: imageURLData!)
            profileImageView.layer.cornerRadius = 13
            profileImageView.layer.masksToBounds = true
            
            bodyTextView.attributedText = SwiftyMarkdown(string: comment.body).attributedString()
            
        }
    }
    
    //MARK: Life cycle
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.backgroundColor = ACAColor().ACALightGrayColor
        
//        bodyTextView.layer.borderWidth = 1
//        bodyTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
//        bodyTextView.layer.cornerRadius = 5
    }
    
}
