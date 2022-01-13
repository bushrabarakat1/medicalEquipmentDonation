//
//  ProfileViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 25/05/1443 AH.
//

import Foundation
import UIKit
import Firebase

class ProfileViewContrller: UIViewController{
    var selectedPost:Post?
    var selectedUserImage:UIImage?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBirthDayLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var titleProfilLabel: UINavigationItem!{
        didSet{
            titleProfilLabel.title = "My Profile".localized
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.text = "Name :".localized
        }
    }
    @IBOutlet weak var birthdayLabel: UILabel!{
        didSet{
            birthdayLabel.text = "BirthDay :".localized
        }
    }
    @IBOutlet weak var countryLabel: UILabel!{
        didSet{
            countryLabel.text = "Country :".localized
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email :".localized
        }
    }
    @IBOutlet weak var phoneNumberLabel: UILabel!{
        didSet{
            phoneNumberLabel.text = "PhonNumber :".localized
        }
    }
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.layer.borderWidth = 2.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var profileView: UIView!{
        didSet{
            profileView.layer.cornerRadius = 40
            profileView.layer.shadowRadius = 15
            profileView.layer.shadowOpacity = 0.6
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
    }
    func getUser() {
        let ref = Firestore.firestore()
        if let currentUser = Auth.auth().currentUser{
            ref.collection("users").document(currentUser.uid).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DB ERROR Posts",error.localizedDescription)
                }
                if let snapshot = snapshot ,let userData = snapshot.data(){
                    
                    let user = User(dict: userData)
                    self.userImageView.loadImageUsingCache(with: user.imageUrl)
                    self.userNameLabel.text = user.userName
                    self.userBirthDayLabel.text = user.birthDay
                    self.userCountryLabel.text = user.country
                    self.userEmailLabel.text = user.email
                    self.userPhoneNumberLabel.text = user.phoneNumber
                }
            }
        }
    }
}



