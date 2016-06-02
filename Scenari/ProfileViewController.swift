//
//  ProfileViewController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 4/29/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: PFQueryTableViewController {
    
    @IBOutlet weak var profileView: UIView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!


    @IBOutlet weak var userProfilePicFile: UIImageView!
    
   // var posts: [Post] = []
    
    
    @IBAction func deleteButton(sender: UIButton){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
        else{
            self.userNameLabel.text = "@<Unknown>"
        }
        // Current user votes count
        let votesCount:Int! = PFUser.currentUser()!["totalVotes"] as? Int
            self.votesCountLabel.text = "\(votesCount)"
        
        
        // Current user post count
        let postCount:Int! = PFUser.currentUser()!["posts"] as? Int
            self.postCountLabel.text = "\(postCount)"
        
        
        //Retrieve Profile Pic 
        if (PFUser.currentUser()?.objectForKey("profile_pic") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_pic") as! PFFile
        
                userImageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData? ,error: NSError?) -> Void in
                    if (imageData != nil){
                        self.userProfilePicFile.image = UIImage(data: imageData!)
                        self.userProfilePicFile.layer.cornerRadius = self.userProfilePicFile.frame.size.width/2
                        self.userProfilePicFile.clipsToBounds = true;

                    }
            })
        }
    }
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:"Questions")
        query.whereKey("postCreator", equalTo: PFUser.currentUser()!)

        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        query.orderByAscending("createdAt")
        
        return query
    }

    /*
    override func viewDidAppear(animated: Bool) {
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("username", equalTo: PFUser.currentUser()!)
    }
   */ 


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileCell
        
        
        let answerATotal: Int! = object?.objectForKey("answer_a_total") as? Int
            cell.answerAcount?.text = "A: \(answerATotal) votes"
        
        let answerBTotal: Int! = object?.objectForKey("answer_b_total") as? Int
            cell.answerBcount?.text = "B: \(answerBTotal) votes"
            
        
        
        cell.questionLabel?.text = object?.objectForKey("question") as? String
        cell.answerALabel?.text = object?.objectForKey("answer_a") as? String
        cell.answerBLabel?.text = object?.objectForKey("answer_b") as? String

        
        return cell
    }
    
    
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
     
        
    }
   // override fun
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
