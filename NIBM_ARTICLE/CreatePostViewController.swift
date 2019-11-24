//
//  CreatePostViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/23/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON

class CreatePostViewController: UIViewController {
    
    
    @IBOutlet weak var txt_img_view: UIImageView!
    
    
    @IBOutlet weak var txt_title: UITextField!
    
  
    @IBOutlet weak var txt_desc: UITextField!
    
    var imagePicker: ImagePicker!
    var avatarImageUrl: String!
     var username: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_img_view.layer.cornerRadius = self.txt_img_view.bounds.height / 2
                      self.txt_img_view.clipsToBounds = true

                      
                      self.imagePicker = ImagePicker(presentationController: self, delegate: self)
                      
                      let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
                      view.addGestureRecognizer(tap)
                      
                     
                      
                      let loggedUserUid = UserDefaults.standard.string(forKey: "UserUID")
                      let ref = Database.database().reference().child("profiles").child(loggedUserUid!)
                      ref.observe(.value, with: { snapshot in
                          
                          let dict = snapshot.value as? [String: AnyObject]
                          let json = JSON(dict as Any)
                          
                          let imageURL = URL(string: json["profileImageUrl"].stringValue)
                          self.txt_img_view.kf.setImage(with: imageURL)
                          
                         // self.FisrtName_txt.text = json["First_Name"].stringValue
                         // self.LastName_txt.text = json["Last_Name"].stringValue
                          //self.txtDOB.text = json["DOB"].stringValue
                         // self.PhoneNum_txt.text = json["Phone_Number"].stringValue
                          
                          
                      })        // Do any additional setup after loading the view.

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_add_photo(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    @IBAction func btn_upload(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        let loggedUserUID = UserDefaults.standard.string(forKey: "UserUID")
        
        let avatarRef = Database.database().reference().child("users").child(loggedUserUID!)
        avatarRef.observe(.value, with: { snapshot in
            
            let dict = snapshot.value as? [String: AnyObject]
            let json = JSON(dict as Any)
            
            self.avatarImageUrl = json["profileImageUrl"].stringValue
        })
        
        guard let title = txt_title.text, !title.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "Title cannot be empty")
            return
        }
        
        guard let description = txt_desc.text, !description.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "Description cannot be empty")
            return
        }
        guard let image = txt_img_view.image,
            let imgData = image.jpegData(compressionQuality: 1.0) else {
                alert.dismiss(animated: false, completion: nil)
                showAlert(message: "An Image must be selected")
                return
        }
        
        let imageName = UUID().uuidString
        
        let reference = Storage.storage().reference().child("articleImages").child(imageName)
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        
        reference.putData(imgData, metadata: metaData) { (meta, err) in
            if let err = err {
                alert.dismiss(animated: false, completion: nil)
                self.showAlert(message: "Error uploading image: \(err.localizedDescription)")
                return
            }
            
            reference.downloadURL { (url, err) in
                if let err = err {
                    alert.dismiss(animated: false, completion: nil)
                    self.showAlert(message: "Error fetching url: \(err.localizedDescription)")
                    return
                }
                
                guard let url = url else {
                    alert.dismiss(animated: false, completion: nil)
                    self.showAlert(message: "Error getting url")
                    return
                }
                
                let imgUrl = url.absoluteString
                
                //                let dbChildName = UUID().uuidString
                
                
                let dbRef = Database.database().reference().child("articles").child("allArticles").childByAutoId()
                
                
                let data = [
                    "title" : title,
                    "description" : description,
                    "imageUrl" : imgUrl,
                    "userUID" : loggedUserUID,
                    "userAvatarImageUrl" : self.avatarImageUrl
                ]
                
                dbRef.setValue(data, withCompletionBlock: { ( err , dbRef) in
                    if let err = err {
                        self.showAlert(message: "Error uploading data: \(err.localizedDescription)")
                        return
                    }
                    alert.dismiss(animated: false, completion: nil)
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                    self.present(vc, animated: true, completion: nil)
                    
                    
                })
                
            }
            
        }
        
    }
    
    func showAlert(message:String)
    {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreatePostViewController: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.txt_img_view.image = image
    }
}
