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
import Fusuma

class ProfileViewController: PFQueryTableViewController {
    
    @IBOutlet weak var profileView: UIView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!


    @IBOutlet weak var userProfilePicFile: UIImageView!
    
   // var posts: [Post] = []
    
   
    
    
    @IBAction func settingsButton(sender: UIButton){
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let uploadCamera = UIAlertAction(title: "Upload Profile Picture", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let fusuma = FusumaViewController()
            //fusuma.delegate = self
            self.presentViewController(fusuma, animated: true, completion: nil)
        })
        
        
        let logoutAction = UIAlertAction(title: "Logout", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            PFUser.logOut()

        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(uploadCamera)
        optionMenu.addAction(logoutAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: - Fusuma Delegate
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving your profile needs to access your photo album.", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        print("Camera roll unauthorized")
    }
    
    // (Optional) Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // (Optional) Called when the close button is pressed.
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Hides navigation hairline
        self.navigationController?.hidesNavigationBarHairline = true

        
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
