//
//  ArticleTableViewCell.swift
//  NIBM_ARTICLE
//
//  Created by Bagya Hennayake on 11/24/19.
//  Copyright © 2019 Dinithika. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
     var User : String?
    
    @IBOutlet weak var avatarBtn: UIButton!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var lblDesc: UILabel!
    
     weak var delegate : ArticleTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.avatarBtn.addTarget(self, action: #selector(avatarBtnClicked(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func avatarBtnClicked(_ sender: UIButton) {
        if let user = User,
            let _ = delegate {
                self.delegate?.avatarTableViewCell(self, avatarButtonTappedFor: user)
         
        }
    }
    
}

protocol ArticleTableViewCellDelegate: AnyObject {
    func avatarTableViewCell(_ articleTableViewCell: ArticleTableViewCell, avatarButtonTappedFor user: String)
}
