//
//  PostMedicalEquipmentController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 24/05/1443 AH.
//


import UIKit
import Firebase
class PostMedicalEquipmentViewController: UIViewController{
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    var selectedUserImage:UIImage?
    
    @IBOutlet weak var postMedicalEquipmentTitleTextField: UITextField!{
        didSet{
            postMedicalEquipmentTitleTextField.placeholder = "Write your title here".localized
        }
    }
    @IBOutlet weak var postMedicalEquipmentDescriptionTextField: UITextView!{
        didSet{
            postMedicalEquipmentDescriptionTextField.layer.cornerRadius = 5
        }
    }
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
    @IBOutlet weak var actionButton: UIButton!{
        didSet{
            actionButton.layer.cornerRadius = 15
            actionButton.layer.shadowRadius = 15
            actionButton.layer.shadowOpacity = 0.3
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = "Title :".localized
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.text = "Description :".localized
        }
    }
    @IBOutlet weak var contactLabel: UILabel!{
        didSet{
            contactLabel.layer.masksToBounds = true
            contactLabel.layer.cornerRadius = 15
            contactLabel.text = "Contact".localized
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
    
    @IBOutlet weak var postMedicalEquipmentImageView: UIImageView!{
        didSet {
            postMedicalEquipmentImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            postMedicalEquipmentImageView.addGestureRecognizer(tapGesture)
        }
    }
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        .......return keybord......
        postMedicalEquipmentTitleTextField.delegate = self
        //        .......hide keybord........
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //        .......user information....
        getUser()
        
//        ...............................................
        
        if let selectedPost = selectedPost,
           let selectedImage = selectedPostImage{
            postMedicalEquipmentTitleTextField.text = selectedPost.title
            postMedicalEquipmentDescriptionTextField.text = selectedPost.description
            postMedicalEquipmentImageView.image = selectedImage
            
            actionButton.setTitle("Update Post".localized, for: .normal)
            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionButton.setTitle("Add Post".localized, for: .normal)
            self.navigationItem.rightBarButtonItem = nil
        }
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
                    self.userEmailLabel.text = user.email
                    self.userPhoneNumberLabel.text = user.phoneNumber
                }
            }
        }
    }
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("posts")
        if let selectedPost = selectedPost {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selectedPost.id).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.id)")
                    // Delete the file
                    storageRef.delete { error in
                        if let error = error {
                            print("Error in storage delete",error)
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }
        }
    }
    @IBAction func buttonAction(_ sender: Any) {
        if let image = postMedicalEquipmentImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let title = postMedicalEquipmentTitleTextField.text,
           let description = postMedicalEquipmentDescriptionTextField.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            //            ref.addDocument(data:)
            var postId = ""
            if let selectedPost = selectedPost {
                postId = selectedPost.id
            }else {
                postId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(postId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var postData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("posts")
                        if let selectedPost = self.selectedPost {
                            postData = [
                                "userId":selectedPost.user.id,
                                "title":title,
                                "description":description,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                                
                            ]
                        }else {
                            postData = [
                                "userId":currentUser.uid,
                                "title":title,
                                "description":description,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                                
                            ]
                        }
                        ref.document(postId).setData(postData) { error in
                            if let error = error {
                                print("FireStore Error",error.localizedDescription)
                            }
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
extension PostMedicalEquipmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
    //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        postMedicalEquipmentImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension PostMedicalEquipmentViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


