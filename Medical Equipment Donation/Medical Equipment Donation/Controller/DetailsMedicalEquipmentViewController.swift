//
//  DetailsMedicalEquipment.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 24/05/1443 AH.
//

import UIKit
class DetailsMedicalEquipmentViewController: UIViewController{
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    var selectedUserImage:UIImage?
    
    @IBOutlet weak var postMedicalEquipmentImageView: UIImageView!{
        didSet{
            postMedicalEquipmentImageView.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var postTitleMedicalEquipmentLable: UILabel!
    @IBOutlet weak var postDescriptionMedicalEquipmentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.layer.borderWidth = 2.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!{
        didSet{
            contactLabel.layer.masksToBounds = true
            contactLabel.layer.cornerRadius = 15
            contactLabel.text = "Contact".localized
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email:".localized
        }
    }
    @IBOutlet weak var phonNumberLabel: UILabel!{
        didSet{
            phonNumberLabel.text = "PhonNumber:".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage,let selectedUserImage = selectedUserImage {
            postTitleMedicalEquipmentLable.text = selectedPost.title
            postDescriptionMedicalEquipmentLabel.text = selectedPost.description
            postMedicalEquipmentImageView.image = selectedImage
            userImageView.image = selectedUserImage
            userNameLabel.text = selectedPost.user.userName
            userEmailLabel.text = selectedPost.user.email
            userPhoneNumberLabel.text = selectedPost.user.phoneNumber
      }
   }
}
