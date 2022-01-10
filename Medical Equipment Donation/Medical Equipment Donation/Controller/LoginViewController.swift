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
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
//            for cornar and shadow design
            emailTextField.layer.cornerRadius = 40
            emailTextField.layer.shadowRadius = 15
            emailTextField.layer.shadowOpacity = 0.6
           
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
//            for cornar and shadow design
            passwordTextField.layer.cornerRadius = 40
            passwordTextField.layer.shadowRadius = 15
            passwordTextField.layer.shadowOpacity = 0.6
        }
    }
    @IBOutlet weak var loginView: UIView!{
        didSet{
//            for corner and shadow design
            loginView.layer.cornerRadius = 40
            loginView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            loginView.layer.shadowRadius = 15
            loginView.layer.shadowOpacity = 0.6
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email :".localized
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "Password :".localized
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.cornerRadius = 20
            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//     ........hide keybord.......
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//      .......return keybord......
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func showPassowrdButton(_ sender: AnyObject) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry{
            if let image = UIImage(systemName: "eye.fill"){
                sender.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
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
extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

 
