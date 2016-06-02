//
//  ScenarioTableViewController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 4/29/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class ScenarioTableViewController: PFQueryTableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, MBProgressHUDDelegate {

    var HUD: MBProgressHUD?
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil)
        }

    }
    
    //MARK - Parse Login
    
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:"Questions")
        query.includeKey("postCreator")
        
        
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByAscending("createdAt")
        
        return query
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScenarioPostCell
        
        
        let answerATotal: Int! = object?.objectForKey("answer_a_total") as? Int
            cell.answerAcount?.text = "A: \(answerATotal) votes"
        
        
        let answerBTotal: Int! = object?.objectForKey("answer_b_total") as? Int
            cell.answerBcount?.text = "B: \(answerBTotal) votes"

        
        
    
        // Show the username
        
        if let postUser = object!["postCreator"] as? PFUser{
            let name = postUser["username"] as! String
            let profileOicture = postUser["profile_pic"] as! PFFile
            
            cell.userPostLabel?.text = "@" + name
        }
        /*
        if let pUserName = object?.objectForKey("PostCreator")?.includeKey("username") as? String {
            cell.userPostLabel?.text = "@" + pUserName
        }
        */


        
        //let credit:String? = object!["postCreator"] as? String
        

        
       
        cell.questionLabel?.text = object?.objectForKey("question") as? String
        cell.userPostLabel?.text = object?.objectForKey("username") as? String
        cell.answerALabel?.text = object?.objectForKey("answer_a") as? String
        cell.answerBLabel?.text = object?.objectForKey("answer_b") as? String
        
        
        
      //  cell.answerAcount?.text = "A: \(answerATotal) votes"
       // cell.answerBcount?.text = "B: \(answerBTotal) votes"
    
       // cell.candidatePartyLabel?.text = object?.objectForKey("candidate_party") as? String
        
        /*
        let imageFile = object?.objectForKey("candidate_picture") as? PFFile
        cell.candidiatePicture?.image = UIImage(named: "placeholder")
        cell.candidiatePicture?.file = imageFile
        cell.candidiatePicture.loadInBackground()
        */
        return cell
    }
    

   
    @IBAction func answerAButton(sender: UIButton){
        loadingHUD()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        
        PFUser.currentUser()!.incrementKey("totalVotes")

        
        //This is where the key increment for the object
        object!.incrementKey("answer_a_total")
        //object!.saveInBackground()
        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.

                self.doneHUD()
                print("Success")
            } else {
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Your vote cannot be submitted. Please check your infomation and try again. Error message: "+(error?.description)!, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.HUD!.hide(true)
                print("Failure")
            }
        }
        
        
        self.tableView.reloadData()
        NSLog("Top Index Path \(hitIndex?.row)")
        /*
        let user = PFUser.currentUser()
        let answerObj = PFObject(className: "Questions")
        
        //  answerObj["answerAArray"] = user?.objectId;
        answerObj.addUniqueObject((user?.objectId)!, forKey: "answerA_array")
        
        answerObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Success")
            } else {
                // There was a problem, check error.description
                print("Failure")
            }
        }*/
        
    }
    
    @IBAction func answerBButton(sender: UIButton){
        loadingHUD()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        
        //this is where I incremented the key for the object
        object!.incrementKey("answer_b_total")
        //object!.saveInBackground()
        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                PFUser.currentUser()!.incrementKey("totalVotes")

                // The object has been saved.
                self.doneHUD()
                print("Success")
            } else {
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Your vote cannot be submitted. Please check your infomation and try again. Error message: "+(error?.description)!, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.HUD!.hide(true)
                print("Failure")
            }
        }
        //doneHUD()
        
        
        self.tableView.reloadData()
        NSLog("Top Index Path \(hitIndex?.row)")
        /*
        let user = PFUser.currentUser()
        let answerObj = PFObject(className: "Questions")
        
        
        //  answerObj["answerAArray"] = user?.objectId;
        answerObj.addUniqueObject((user?.objectId)!, forKey: "answerB_array")
        
        answerObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Success")
            } else {
                // There was a problem, check error.description
                print("Failure")
            }
        }
 */
    }
    
    //MARK - MBProgressHUD Customization
    func doneHUD(){
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD!.customView = UIImageView(image: UIImage(named: "Checkmark.png"))
        
        // Set custom view mode
        HUD!.mode = .CustomView;
        
        HUD!.delegate = self;
        HUD!.labelText = "Answer Submitted";
        
        HUD!.show(true)
        HUD!.hide(true, afterDelay:3)
    }

    func loadingHUD(){
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Submitting..."
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailVC = segue.destinationViewController as! ScenarioPostDetailViewController
            let object = self.objectAtIndexPath(indexPath)
            detailVC.questionStringParse = object?.objectForKey("question") as! String
            detailVC.answerAStringParse = object?.objectForKey("answer_a") as! String
            detailVC.answerBStringParse = object?.objectForKey("answer_b") as! String
          //  detailVC.bioString = object?.objectForKey("candidate_bio") as! String
            
           // detailVC.pictureFile = object?.objectForKey("candidate_picture") as! PFFile
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
     }
    
    
}


