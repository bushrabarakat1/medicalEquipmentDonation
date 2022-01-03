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
    
    @IBOutlet weak var postMedicalEquipmentImageView: UIImageView!
    @IBOutlet weak var postTitleMedicalEquipmentLable: UILabel!
    @IBOutlet weak var postDescriptionMedicalEquipmentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phonNumberLabel: UILabel!
    
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
