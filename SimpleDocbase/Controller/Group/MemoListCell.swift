//
//  MemoListCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/20.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

protocol MemoListCellDelegate {
    func emptyTag(image: UIImageView)
}

class MemoListCell: UITableViewCell {
    
    var delegate: MemoListCellDelegate?
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    @IBOutlet weak var tagLabelHeight: NSLayoutConstraint!
    

    var memo: Memo? {
        didSet {
            guard let memo = memo else {
                return
            }
            titleLabel.text = memo.title
            
            if memo.title.hasPrefix("SimpleDocbase_") {
                bodyLabel.text = "勤務表はDocbaseから確認してください。"
            } else {
                bodyLabel.text = memo.body
            }
            
//            if memo.tags.isEmpty {
//                tagImageView.isHidden = true
//                let rect:CGRect = CGRect(x:0, y:0, width:0, height:0)
//                tagImageView.frame = rect
//                setNeedsUpdateConstraints()
                
//                tagLabelHeight.constant = 0
//                delegate?.emptyTag(image: tagImageView)
            
//            }
            
//            var tags: [String] = []
//            for i in 0..<memo.tags.count{
//                tags.append(memo.tags[i].name)
//            }
//            tagLabel.text = tags.joined(separator: ", ")
            
            //臨時コード
            if memo.tags.isEmpty {
                tagLabel.text = "タグなし"
                tagLabel.textColor = UIColor.lightGray
            } else {
                var tags: [String] = []
                for i in 0..<memo.tags.count{
                    tags.append(memo.tags[i].name)
                }
                tagLabel.text = tags.joined(separator: ", ")
            }
            
            let imageURL = URL(string: memo.user.profile_image_url)
            let imageURLData = try? Data(contentsOf: imageURL!)
            profileImageView.image = UIImage(data: imageURLData!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.textColor = UIColor.black
    }
    
}

