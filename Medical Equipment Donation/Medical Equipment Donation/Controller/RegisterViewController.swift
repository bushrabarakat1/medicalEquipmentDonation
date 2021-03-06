//
//  RegisterViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//


import UIKit
import Firebase
import Contacts
import SwiftUI
class RegisterViewController: UIViewController{
    
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userGenderTextField: UITextField!
    @IBOutlet weak var userBirthDayTextField: UITextField!
    @IBOutlet weak var userCountryTextField: UITextField!
    @IBOutlet weak var userEmailTextFiled: UITextField!
    @IBOutlet weak var userPhoneNumberTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    @IBOutlet weak var containtRegisterInformationView: UIView!{
        didSet{
            //.....for corner design.......
            containtRegisterInformationView.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.text = "Name :".localized
        }
    }
    @IBOutlet weak var genderLabel: UILabel!{
        didSet{
            genderLabel.text = "Gender :".localized
        }
    }
    @IBOutlet weak var birthDayLabel: UILabel!{
        didSet{
            birthDayLabel.text = "BirthDay :".localized
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
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "Password :".localized
        }
    }
    @IBOutlet weak var confirmPasswordLabel: UILabel!{
        didSet{
            confirmPasswordLabel.text = "ConfirmPassword :".localized
        }
    }
    @IBOutlet weak var registerAsBenefactorLabel: UILabel!{
        didSet{
            registerAsBenefactorLabel.text = "Register as Benefactor".localized
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.layer.cornerRadius = 20
            registerButton.setTitle("Register".localized, for: .normal)
        }
    }
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectimage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var registerView: UIView!{
        didSet{
            //.....for corner and shadow design.......
            registerView.layer.cornerRadius = 40
            registerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            registerView.layer.shadowRadius = 15
            registerView.layer.shadowOpacity = 0.6
        }
    }
    @IBOutlet weak var userTypeButton: UIButton!{
        didSet{
            //......for corner and shadow design.......
            userTypeButton.layer.borderWidth = 0.5
            userTypeButton.layer.borderColor = UIColor.systemBlue.cgColor
            userTypeButton.layer.cornerRadius = userTypeButton.frame.size.width / 2.0
            userTypeButton.backgroundColor = .systemBackground
        }
    }
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        //......return keybord......
        userNameTextField.delegate = self
        userGenderTextField.delegate = self
        userBirthDayTextField.delegate = self
        userCountryTextField.delegate = self
        userEmailTextFiled.delegate = self
        userPhoneNumberTextField.delegate = self
        userPasswordTextField.delegate = self
        userConfirmPasswordTextField.delegate = self
        
        //......hide keybord.........
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//       .....eye password......
        userPasswordTextField.rightView = showPasswordButton
        userPasswordTextField.rightViewMode = .always
        userConfirmPasswordTextField.rightView = showConfirmPasswordButton
        userConfirmPasswordTextField.rightViewMode = .always
    }
    
    //...........for hide password..........
    @IBAction func showPasswordButton(_ sender: AnyObject) {
        userPasswordTextField.isSecureTextEntry.toggle()
        if userPasswordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill"){
                sender.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }

    @IBAction func showConfirmPasswordButton(_ sender: AnyObject) {
        userConfirmPasswordTextField.isSecureTextEntry.toggle()
        if userConfirmPasswordTextField.isSecureTextEntry{
            if let image = UIImage(systemName: "eye.fill"){
                sender.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    //................for ather user................
    var isBenefactor = false
    @IBAction func userTypeButton(_ sender: Any) {
        if isBenefactor {
            userTypeButton.backgroundColor = .systemBackground
            isBenefactor = false
        }else{
            userTypeButton.backgroundColor = .systemBlue
            isBenefactor = true
        }
    }
    
    //.................register Button...............
    @IBAction func handelRegisterButton(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let userName = userNameTextField.text,
           let gender = userGenderTextField.text,
           let birthDay = userBirthDayTextField.text,
           let country = userCountryTextField.text,
           let email = userEmailTextFiled.text,
           let phoneNumber = userPhoneNumberTextField.text,
           let password = userPasswordTextField.text,
           let confirmPassword = userConfirmPasswordTextField.text,
           password == confirmPassword{
            Activity.showIndicator(parentView: self.view , childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                    print ("Registration Storage Error", error.localizedDescription)
                }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error {
                            Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            print("Registration Storage Error",error.localizedDescription)
                        }
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                print("Registration Storage Download Url Error",error.localizedDescription)
                            }
                            if let url = url {
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:Any] = [
                                    "id": authResult.user.uid,
                                    "userName": userName,
                                    "gender": gender,
                                    "birthDay": birthDay,
                                    "country": country,
                                    "email": email,
                                    "phoneNumber": phoneNumber,
                                    "imageUrl": url.absoluteString,
                                    "type": self.isBenefactor
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error {
                                        Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                        print("Registration Database error",error.localizedDescription)
                                    }else {
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
                }
            }
        }
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func selectimage(){
        showAlert()
    }
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you wont to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(from sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ Picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
