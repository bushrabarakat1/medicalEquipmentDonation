//
//  PostCellMedicalEquipment.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 24/05/1443 AH.
//

import UIKit

class PostCellMedicalEquipment
: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!{
        didSet{
            //.......for corner and shadow......
            postImageView.layer.cornerRadius = 30
            postImageView.layer.shadowRadius = 15
            postImageView.layer.shadowOpacity = 0.6
            postImageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            //.........for corner.................
            userImageView.layer.borderWidth = 2.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var cellView: UIView!{
        didSet{
            //....for cornar and shadow design....
            cellView.layer.cornerRadius = 30
            cellView.layer.shadowRadius = 10
            cellView.layer.shadowOpacity = 0.3
            cellView.layer.cornerRadius = 20
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(with post:Post) -> UITableViewCell {
        postTitleLabel.text = post.title
        postDescriptionLabel.text = post.description
        postImageView.loadImageUsingCache(with: post.imageUrl)
        userNameLabel.text = post.user.userName
        userImageView.loadImageUsingCache(with: post.user.imageUrl)
        
        return self
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
        postImageView.image = nil
    }
}
