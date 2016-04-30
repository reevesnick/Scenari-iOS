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

class ScenarioTableViewController: PFQueryTableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    
    
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
/*
        let loginVC = PFLogInViewController()
        loginVC.fields = PFLogInFields(rawValue: PFLogInFields.UsernameAndPassword.rawValue | PFLogInFields.LogInButton.rawValue)
 
 */
    }
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:"Questions").includeKey("postCreator")
       // query.includeKey("postCreator")
        
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
        

        
        cell.questionLabel?.text = object?.objectForKey("question") as? String
        cell.userPostLabel?.text = object?.objectForKey("username") as? String
        cell.answerALabel?.text = object?.objectForKey("answer_a") as? String
        cell.answerBLabel?.text = object?.objectForKey("answer_b") as? String
    
       // cell.candidatePartyLabel?.text = object?.objectForKey("candidate_party") as? String
        
        /*
        let imageFile = object?.objectForKey("candidate_picture") as? PFFile
        cell.candidiatePicture?.image = UIImage(named: "placeholder")
        cell.candidiatePicture?.file = imageFile
        cell.candidiatePicture.loadInBackground()
        */
        return cell
    }
   /*
    @IBAction func answerAButton(sender: UIButton){
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
        }
        
    }
    
    @IBAction func answerBButton(sender: UIButton){
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
    }
*/
    
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


