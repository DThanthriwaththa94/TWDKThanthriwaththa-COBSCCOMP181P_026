//
//  HomeTableViewController.swift
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

class HomeTableViewController: UITableViewController {
    
    private var articleIDs = [String]()
    private var items = [JSON](){
        didSet{
            tableView.reloadData()
        }
    }

    var userid : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        nothingToShow()
        let ref = Database.database().reference().child("articles")
        ref.observe(.value, with: { snapshot in
            self.items.removeAll()
            self.articleIDs.removeAll()
            let dict = snapshot.value as? [String: AnyObject]
            let json = JSON(dict as Any)
            
            for object in json["allArticles"]{
                self.articleIDs.append(object.0)
                self.items.append(object.1)
            }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 580
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ArticleTableViewCell
        
        cell.lblTitle.text = items[indexPath.row]["title"].stringValue
        cell.lblDesc.text = items[indexPath.row]["description"].stringValue
        
        
        let imageURL = URL(string: items[indexPath.row]["imageUrl"].stringValue)
        cell.imgPhoto.kf.setImage(with: imageURL)
        
        let avatarImageURL = URL(string: items[indexPath.row]["userAvatarImageUrl"].stringValue)
        cell.avatarBtn.kf.setImage(with: avatarImageURL, for: .normal)
        cell.avatarBtn.kf.setBackgroundImage(with: avatarImageURL, for: .normal)
        
       // cell.avatarBtn.kf.setImage(with: avatarImageURL)
        
        cell.User = items[indexPath.row]["userUID"].stringValue
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let loggedUserUid = UserDefaults.standard.string(forKey: "UserUID")
        let tempUID = items[indexPath.row]["userUID"].stringValue
        if loggedUserUid == tempUID{
            let vc = EditPostViewController(nibName: "EditPostViewController", bundle: nil)
            vc.article = items[indexPath.row]
            vc.articleID = articleIDs[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = SingleArticleViewController(nibName: "SingleArticleViewController", bundle: nil)
            vc.article = items[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func showAlert(message:String)
    {
        
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func nothingToShow(){
        let lable = UILabel(frame: .zero)
        lable.textColor = UIColor.darkGray
        lable.numberOfLines = 0
        lable.text = "Oops, /n No articles to show"
        lable.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = lable
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTableViewController: ArticleTableViewCellDelegate{
    func avatarTableViewCell(_ PostViewTableViewCell: ArticleTableViewCell, avatarButtonTappedFor user: String) {
           
           let vc = UserViewController(nibName: "UserViewController", bundle: nil)
           vc.UID = user
           print(user)
           navigationController?.pushViewController(vc, animated: true)
       }
}
