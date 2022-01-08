//
//  LandingViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//

import Foundation
import UIKit
class LandingViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = 40
        }
    }
    
    @IBOutlet weak var registAndLoginView: UIView!{
        didSet{
//             corner and shadow design
            registAndLoginView.layer.cornerRadius = 40
            registAndLoginView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            registAndLoginView.layer.shadowOffset = CGSize(width: 10, height: 10)
            registAndLoginView.layer.shadowRadius = 20
            registAndLoginView.layer.shadowOpacity = 0.9
            
        }
    }
    
    @IBOutlet weak var helloLabel: UILabel!{
        didSet{
            helloLabel.text = "H E L L O".localized
        }
    }
    @IBOutlet weak var registerLabel: UIButton!{
        didSet{
            registerLabel.layer.cornerRadius = 20
            registerLabel.setTitle("Register".localized, for: .normal)
        }
    }
    @IBOutlet weak var loginLabel: UIButton!{
        didSet{
            loginLabel.layer.cornerRadius = 20
            loginLabel.setTitle("Login".localized, for: .normal)
        }
    }
    @IBOutlet weak var langugeChangeSegmented: UISegmentedControl!{
        didSet {
//            for shadow design
            langugeChangeSegmented.layer.shadowOffset = CGSize(width: 10, height: 10)
            langugeChangeSegmented.layer.shadowRadius = 20
            langugeChangeSegmented.layer.shadowOpacity = 0.9
            
//         ___________________________________________________________
            if let language = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch language {
                case "ar":
                    langugeChangeSegmented.selectedSegmentIndex = 0
                case "en":
                    langugeChangeSegmented.selectedSegmentIndex = 1
                case "fr":
                    langugeChangeSegmented.selectedSegmentIndex = 2
                default:
                    let localLang =  Locale.current.languageCode
                     if localLang == "ar" {
                         langugeChangeSegmented.selectedSegmentIndex = 0
                     } else if localLang == "fr"{
                         langugeChangeSegmented.selectedSegmentIndex = 2
                     }else {
                         langugeChangeSegmented.selectedSegmentIndex = 1
                     }
                  
                }
            
            }else {
                let localLang =  Locale.current.languageCode
                 if localLang == "ar" {
                     langugeChangeSegmented.selectedSegmentIndex = 0
                 } else if localLang == "fr"{
                     langugeChangeSegmented.selectedSegmentIndex = 2
                 }else {
                     langugeChangeSegmented.selectedSegmentIndex = 1
                 }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        registerLabel.layer.cornerRadius = 20
//        loginLabel.layer.cornerRadius = 20
//        self.imageView.layer.shadowOffset = CGSize(width: 10, height: 10)
//        self.imageView.layer.shadowRadius = 15
//        self.imageView.layer.shadowOpacity = 0.3
        
    }
    
    @IBAction func langugeSegmented(_ sender:UISegmentedControl) {
        if let language = sender.titleForSegment(at: sender.selectedSegmentIndex)?.lowercased(){
            if language == "ar"{
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                  }else{
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                  }
            UserDefaults.standard.set(language, forKey: "currentLanguage")
            Bundle.setLanguage(language)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
        }
    }

}
    extension String{
        var localized: String{
            return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
        }
    }
