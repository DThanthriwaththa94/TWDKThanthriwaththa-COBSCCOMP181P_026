//
//  MyProfileViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/23/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON
import FirebaseAuth

class MyProfileViewController: UIViewController {
    
    var imagePicker: ImagePicker!
    
    
    @IBOutlet weak var txt_profile_img: UIImageView!
    
    
    @IBOutlet weak var txt_fname: UITextField!
    
    
    @IBOutlet weak var txt_lname: UITextField!
    
    
    @IBOutlet weak var txt_mbNo: UITextField!
    
    
    @IBOutlet weak var txt_dob: UITextField!
    
    var age: Int?
    
    @IBAction func btn_changeProfile(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    @IBOutlet weak var txt_btn_signout: UIButton!
    
    
    @IBAction func btn_signOut(_ sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey: "LoggedUser")
        UserDefaults.standard.removeObject(forKey: "LoggedIn")
        UserDefaults.standard.removeObject(forKey: "UserUID")
        UserDefaults.standard.synchronize()
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginstroyId")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btn_update(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        
        guard let FName = txt_fname.text, !FName.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "First Name cannot be empty")
            return
        }
        
        guard let LName = txt_lname.text, !LName.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "Last Name cannot be empty")
            return
        }
        
        guard let PhoneNumber = txt_mbNo.text, !PhoneNumber.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "Number cannot be empty")
            return
        }
        
        guard let DOB = txt_dob.text, !DOB.isEmpty else {
            alert.dismiss(animated: false, completion: nil)
            showAlert(message: "Number cannot be empty")
            return
        }
        
        let loggedUserUid = UserDefaults.standard.string(forKey: "UserUID")
        let loggedUserEmail = UserDefaults.standard.string(forKey: "LoggedUser")
        
        guard let image = txt_profile_img.image,
            let imgData = image.jpegData(compressionQuality: 1.0) else {
                alert.dismiss(animated: false, completion: nil)
                showAlert(message: "An Image must be selected")
                return
        }
        
        let imageName = UUID().uuidString
        
        let reference = Storage.storage().reference().child("profileImages").child(imageName)
        
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
                
                //  let dbChildName = UUID().uuidString
                
                
                let dbRef = Database.database().reference().child("users").child(loggedUserUid!)
                
                
                let data = [
                    "First_Name" : FName,
                    "Last_Name" : LName,
                    "profileImageUrl" : imgUrl,
                    "DOB" : DOB,
                    "Phone_Number" : PhoneNumber,
                    "Email" : loggedUserEmail
                    
                ]
                
                dbRef.setValue(data, withCompletionBlock: { ( err , dbRef) in
                    if let err = err {
                        self.showAlert(message: "Error uploading data: \(err.localizedDescription)")
                        return
                    }
                    alert.dismiss(animated: false, completion: nil)
                    self.showAlert(message: "Successfully Updated")
                    
                })
                
            }
            
        }
        
        
    }
    
    @objc func datePickerDone() {
           txt_dob.resignFirstResponder()
       }
       
       @objc func handleDatePicker(sender: UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MMM-yyyy"
           
           txt_dob.text = dateFormatter.string(from: sender.date)
           
           let now = Date()
           let birthday: Date = sender.date
           let calendar = Calendar.current
           
           let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
           age = ageComponents.year!
           print(age!)
       }
    
    @IBAction func txt_dobClick(_ sender: UITextField) {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        sender.inputAccessoryView = toolBar
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let loggedUserUid = UserDefaults.standard.string(forKey: "UserUID")
        let ref = Database.database().reference().child("users").child(loggedUserUid!)
        ref.observe(.value, with: { snapshot in
            
            let dict = snapshot.value as? [String: AnyObject]
            let json = JSON(dict as Any)
            
            let imageURL = URL(string: json["profileImageUrl"].stringValue)
            self.txt_profile_img.kf.setImage(with: imageURL)
            
            self.txt_fname.text = json["First_Name"].stringValue
            self.txt_lname.text = json["Last_Name"].stringValue
            self.txt_dob.text = json["DOB"].stringValue
            self.txt_mbNo.text = json["Phone_Number"].stringValue
            
            
        })

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
              super.didReceiveMemoryWarning()
              // Dispose of any resources that can be recreated.
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

extension MyProfileViewController:
ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.txt_profile_img.image = image
    }
}
