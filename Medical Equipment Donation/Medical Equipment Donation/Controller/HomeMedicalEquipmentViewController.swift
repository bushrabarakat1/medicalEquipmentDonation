//
//  HomeMedicalEquipment.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//


import UIKit
import Firebase
class HomeMedicalEquipmentViewController: UIViewController{
  
    var posts = [Post]()
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    var selectedUserImage:UIImage?
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UINavigationItem!{
        didSet{
            titleLabel.title = "MedicalEquipment".localized
        }
    }
    
    @IBOutlet weak var postMedicalEquipmentTableView: UITableView!{
        didSet{
            postMedicalEquipmentTableView.delegate = self
            postMedicalEquipmentTableView.dataSource = self
           
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        
//        for user type
        if let currentUser = Auth.auth().currentUser{
            let ref = Firestore.firestore()
            ref.collection("users").document(currentUser.uid).getDocument { userSnapshot, error in
                if let error = error {
                    print("ERROR user Data",error.localizedDescription)
                }
                if let userSnapshot = userSnapshot,
                   let userData = userSnapshot.data(){
                    let user = User(dict:userData)
                    if user.type == false{
                        self.navigationItem.rightBarButtonItem = nil
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    func getPosts() {
        let ref = Firestore.firestore()
        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("POST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                    if let userId = postData["userId"] as? String {
                        ref.collection("users").document(userId).getDocument { userSnapshot, error in
                            if let error = error {
                                print("ERROR user Data",error.localizedDescription)
                                
                            }
                            if let userSnapshot = userSnapshot,
                               let userData = userSnapshot.data(){
                                let user = User(dict:userData)
                                let post = Post(dict:postData,id:diff.document.documentID,user:user)

                                
                    switch diff.type {
                    case .added :
                        
                       
                                    self.postMedicalEquipmentTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)
                                        
                                        self.postMedicalEquipmentTableView.insertRows(at: [IndexPath(row:self.posts.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.posts.insert(post,at:0)
                                        
                                        self.postMedicalEquipmentTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }
                                    
                                    self.postMedicalEquipmentTableView.endUpdates()
                                    
                                    
                        
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.posts.first(where: {$0.id == postId}),
                           let updateIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            let newPost = Post(dict:postData, id: postId, user: currentPost.user)
                            self.posts[updateIndex] = newPost
                            
                            self.postMedicalEquipmentTableView.beginUpdates()
                            self.postMedicalEquipmentTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                            self.postMedicalEquipmentTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.postMedicalEquipmentTableView.endUpdates()
                            
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            self.posts.remove(at: deleteIndex)
                            
                            self.postMedicalEquipmentTableView.beginUpdates()
                            self.postMedicalEquipmentTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                            self.postMedicalEquipmentTableView.endUpdates()
                            
                        }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! PostMedicalEquipmentViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
                vc.selectedUserImage = selectedUserImage
            }else if identifier == "toDetailsVC"{
                let vc = segue.destination as! DetailsMedicalEquipmentViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
                vc.selectedUserImage = selectedUserImage
            }
        }
    }
}


extension HomeMedicalEquipmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCellMedicalEquipment
        return cell.configure(with: posts[indexPath.row])
    }
    
}
extension HomeMedicalEquipmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostCellMedicalEquipment
        selectedPostImage = cell.postImageView.image
        selectedUserImage = cell.userImageView.image
        selectedPost = posts[indexPath.row]
        //        print("AUTH",Auth.auth().currentUser)
        print("AUTH",posts[indexPath.row].user.id)
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == posts[indexPath.row].user.id{
            performSegue(withIdentifier: "toPostVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
        }
    }
    
}
          


