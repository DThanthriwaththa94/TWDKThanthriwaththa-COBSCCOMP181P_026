//
//  UserSignInViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/23/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserSignInViewController: UIViewController {

    @IBOutlet weak var txt_email: UITextField!
    
    
    @IBOutlet weak var txt_pwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_signin_click(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
         
         let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
         loadingIndicator.hidesWhenStopped = true
         loadingIndicator.style = UIActivityIndicatorView.Style.gray
         loadingIndicator.startAnimating();
         
         alert.view.addSubview(loadingIndicator)
         present(alert, animated: true, completion: nil)
         
        
         
         
         Auth.auth().signIn(withEmail: txt_email.text!, password: txt_pwd.text!) { (user, error) in
             
             if(error == nil)
             {
                 var user_email:String?
                 var UID: String?
                 if let user = user {
                     _ = user.user.displayName
                     user_email = user.user.email
                     UID = user.user.uid
                     print("eeeeeeeeeee\(user_email!)")
                 }
                 
                 //self.showAlert(message: "SignIn Successfully! Email: \(user_email!)")
                 UserDefaults.standard.set(user_email, forKey: "LoggedUser")
                 UserDefaults.standard.set(UID, forKey: "UserUID")
                 UserDefaults.standard.set(true, forKey: "LoggedIn")
                 UserDefaults.standard.synchronize()
                 alert.dismiss(animated: false, completion: nil)
                 let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                 self.present(vc, animated: true, completion: nil)
                 
             }
             else{
                 if let errorCode = AuthErrorCode(rawValue: error!._code) {
                     switch errorCode {
                     case.wrongPassword:
                         alert.dismiss(animated: false, completion: nil)
                         self.showAlert(message: "You entered an invalid password please try again!")
                         break
                     case.userNotFound:
                         alert.dismiss(animated: false, completion: nil)
                         self.showAlert(message: "There is no matching account with that email")
                         break
                     default:
                         alert.dismiss(animated: false, completion: nil)
                         self.showAlert(message: "Unexpected error \(errorCode.rawValue) please try again!")
                         print("Creating user error \(error.debugDescription)!")
                     }
                 }
             }
         }
        
        
    }
    
    
    @IBAction func btn_fogotpwd_click(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: txt_email.text!) { error in
            if self.txt_email.text?.isEmpty==true{
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
            }
            if error != nil && self.txt_email.text?.isEmpty==false{
                let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailAlertSent, animated: true, completion: nil)
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
