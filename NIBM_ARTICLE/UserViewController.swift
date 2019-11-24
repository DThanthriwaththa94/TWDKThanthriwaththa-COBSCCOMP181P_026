//
//  UserViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/23/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import Kingfisher


class UserViewController: UIViewController {
    
    var UID: String?
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var txtPhone: UILabel!
    
    
    @IBOutlet weak var txtEmail: UILabel!
    
    
    @IBOutlet weak var txtDOB: UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child("users").child(UID!)
        ref.observe(.value, with: { snapshot in
            
            let dict = snapshot.value as? [String: AnyObject]
            let json = JSON(dict as Any)
            
            let imageURL = URL(string: json["profileImageUrl"].stringValue)
            self.imgProfilePic.kf.setImage(with: imageURL)
            
            self.txtName.text = "\(json["First_Name"].stringValue) \(json["Last_Name"].stringValue)"
            self.txtDOB.text = json["DOB"].stringValue
            self.txtPhone.text = json["Phone_Number"].stringValue
            self.txtEmail.text = json["Email"].stringValue
            
        })

        // Do any additional setup after loading the view.
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
