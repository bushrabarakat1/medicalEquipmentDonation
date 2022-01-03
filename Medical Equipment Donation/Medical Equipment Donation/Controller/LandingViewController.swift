//
//  LandingViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//

import Foundation
import UIKit
class LandingViewController: UIViewController{
   
    @IBOutlet weak var helloLabel: UILabel!{
        didSet{
            helloLabel.text = "HELLO".localized
        }
    }
    @IBOutlet weak var registerLabel: UIButton!{
        didSet{
            registerLabel.setTitle("Register".localized, for: .normal)
        }
    }
    @IBOutlet weak var loginLabel: UIButton!{
        didSet{
            loginLabel.setTitle("Login".localized, for: .normal)
        }
    }
    @IBOutlet weak var langugeChangeSegmented: UISegmentedControl!{
        didSet {
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
