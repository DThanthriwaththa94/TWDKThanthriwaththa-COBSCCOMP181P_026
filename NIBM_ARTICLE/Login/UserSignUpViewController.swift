//
//  UserSignUpViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/23/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserSignUpViewController: UIViewController {

    
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_pwd: UITextField!
    
    @IBOutlet weak var txt_confirmPwd: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_register(_ sender: UIButton) {
        
        if ((txt_email.text?.isEmpty)! || (txt_pwd.text?.isEmpty)!)
        {
            self.showAlert(message: "All fields are mandatory!")
            return
        } else {
            if txt_pwd.text == txt_confirmPwd.text{
                Auth.auth().createUser(withEmail: txt_email.text!, password: txt_pwd.text!)
                {
                    (authResult, error) in
                    print("authResult ", authResult as Any)
                    if ((error == nil)) {
                        
                        self.showAlert(message: "Signup Successfully!")
                        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginstroyId")
                        self.present(vc, animated: true, completion: nil)
                      
                        
                    } else {
                        self.showAlert(message: (error?.localizedDescription)!)
                    }
                }
            }
            else {
                
                self.showAlert(message: "Passwords don't match")
                
                
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
