//
//  SingleArticleViewController.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/24/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class SingleArticleViewController: UIViewController {
    
    
    @IBOutlet weak var btnAvatar: UIButton!
    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    
    
    @IBOutlet weak var txtTitle: UILabel!
    
    
    @IBOutlet weak var txtDescription: UILabel!
    
    var article: JSON?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = article!["title"].stringValue
        txtDescription.text = article!["description"].stringValue
        
        let imageURL = URL(string: article!["imageUrl"].stringValue)
        imgPhoto.kf.setImage(with: imageURL)
        
        let avatarURL = URL(string: article!["userAvatarImageUrl"].stringValue)
        btnAvatar.kf.setImage(with: avatarURL, for: .normal)
        btnAvatar.kf.setBackgroundImage(with: avatarURL, for: .normal)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func avatarBtnClick(_ sender: UIButton) {
        let vc = UserViewController(nibName: "UserViewController", bundle: nil)
        vc.UID = article!["userUID"].stringValue
        
        navigationController?.pushViewController(vc, animated: true)
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
