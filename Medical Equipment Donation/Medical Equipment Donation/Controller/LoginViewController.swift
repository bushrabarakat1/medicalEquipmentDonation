//
//  LoginViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//


import UIKit
import Firebase
class LoginViewController : UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email".localized
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "Password".localized
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text{
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

 
