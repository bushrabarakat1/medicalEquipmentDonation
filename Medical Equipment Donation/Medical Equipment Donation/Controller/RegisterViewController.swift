//
//  RegisterViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//


import UIKit
import Firebase
import Contacts
class RegisterViewController: UIViewController{
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectimage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userGenderTextField: UITextField!
    @IBOutlet weak var userBirthDayTextField: UITextField!
    @IBOutlet weak var userCountryTextField: UITextField!
    @IBOutlet weak var userEmailTextFiled: UITextField!
    @IBOutlet weak var userPhoneNumberTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    @IBAction func handelRegisterButton(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
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
                    print ("Registration Storage Error", error.localizedDescription)
                }
                if let authResult = authResult {
                    
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error {
                            print("Registration Storage Error",error.localizedDescription)
                        }
                        storageRef.downloadURL { url, error in
                            if let error = error {
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
                                    "type": false
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error {
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
