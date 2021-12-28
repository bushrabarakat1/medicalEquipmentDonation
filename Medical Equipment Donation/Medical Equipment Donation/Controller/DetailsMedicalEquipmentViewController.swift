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
    
    @IBOutlet weak var postMedicalEquipmentImageView: UIImageView!
    
    @IBOutlet weak var postTitleMedicalEquipmentLable: UILabel!
    @IBOutlet weak var postDescriptionMedicalEquipmentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            postTitleMedicalEquipmentLable.text = selectedPost.title
            postDescriptionMedicalEquipmentLabel.text = selectedPost.description
            postMedicalEquipmentImageView.image = selectedImage
        }
        // Do any additional setup after loading the view.
}
}
