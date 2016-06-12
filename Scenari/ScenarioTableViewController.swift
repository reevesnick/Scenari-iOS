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
import DZNEmptyDataSet
import ParseFacebookUtils
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics



class ScenarioTableViewController: PFQueryTableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, MBProgressHUDDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var answerAButton: UIButton!
    @IBOutlet weak var answerBButton: UIButton!
    
    let permissions = ["public_profile", "email", "user_friends"]

 

    var HUD: MBProgressHUD?
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    @IBAction func composeScenarioButton(sender: AnyObject){
        let viewController:UIViewController = UIStoryboard(name: "CreateScenario", bundle: nil).instantiateInitialViewController()! as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        self.tableView.tableFooterView = UIView()
        
 
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            let loginViewController = LoginView()
            loginViewController.signUpController = SignupView()
            loginViewController.fields = [PFLogInFields.UsernameAndPassword,
                                          PFLogInFields.LogInButton,
                                          PFLogInFields.SignUpButton,
                                          PFLogInFields.PasswordForgotten,
                                          PFLogInFields.Facebook]
            
            loginViewController.facebookPermissions = ["public_profile","email","user_friends"]

            
            

            loginViewController.delegate = self
            loginViewController.signUpController?.delegate = self
            
          
            self.presentViewController(loginViewController, animated: false, completion: nil)
        }
    }
    
    //MARK - Parse Login
    
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:"Questions")
        query.includeKey("postCreator")
        //query.whereKey("username", equalTo:username)

        
        if(objects?.count == 0)
        {
           query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        return query
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScenarioPostCell
        
        
        let answerATotal: Int! = object?.objectForKey("answer_a_total") as? Int
            cell.answerAcount?.text = "A: \(answerATotal) votes"
        
        
        let answerBTotal: Int! = object?.objectForKey("answer_b_total") as? Int
            cell.answerBcount?.text = "B: \(answerBTotal) votes"

        
        
    
        // Show the username and picture
        
        let postUser = object!["postCreator"] as? PFUser
            let profilePicture = postUser?["profile_pic"] as? PFFile
            let pUserName: String! = postUser?.username
        
        
 
            cell.profilePic?.image = UIImage(named: "placeholder")
            cell.profilePic?.file = profilePicture
            cell.profilePic.loadInBackground()
            cell.userPostLabel?.text = "@\(pUserName)"
        
        
    
        
        // Convert Date to String
        let dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM/dd/yyyy H:mm at"
        
        
        cell.dateCreated?.text = dataFormatter.stringFromDate(object!.createdAt!)
        
        cell.questionLabel?.text = object?.objectForKey("question") as? String
        cell.answerALabel?.text = object?.objectForKey("answer_a") as? String
        cell.answerBLabel?.text = object?.objectForKey("answer_b") as? String
        

        
        return cell
    }
    
    @IBAction func answerAnyButton(sender: UIButton){
        
    }

   
    @IBAction func answerAButton(sender: AnyObject){
        loadingHUD()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        let user = PFUser.currentUser()
        
        PFUser.currentUser()!.incrementKey("totalVotes")
        object!.addUniqueObject((user?.objectId)!, forKey: "answerVoted")


        
        //This is where the key increment for the object
        object!.incrementKey("answer_a_total")
        //object!.saveInBackground()
        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                
                
                Answers.logCustomEventWithName("Answer A Votes - Total",
                    customAttributes: [:])

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
        //NSLog("Top Index Path \(hitIndex?.row)")
    }
    
    @IBAction func answerBButton(sender: AnyObject){
        loadingHUD()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        let user = PFUser.currentUser()
        
        //this is where I incremented the key for the object
        object!.incrementKey("answer_b_total")
        object!.addUniqueObject((user?.objectId)!, forKey: "answerVoted")

        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                PFUser.currentUser()!.incrementKey("totalVotes")
                
                
                Answers.logCustomEventWithName("Answer B Votes - Total",
                    customAttributes: [:])

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
        HUD!.hide(true, afterDelay:1)
    }

    func loadingHUD(){
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Submitting..."
        
    }
    
    
    func loadNewFaceookData(){
        let request:FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            if error == nil{
                if let dict = result as? Dictionary<String, AnyObject>{
                    let name:String = dict["name"] as AnyObject? as! String
                    let facebookID:String = dict["id"] as AnyObject? as! String
                    let email:String = dict["email"] as AnyObject? as! String
                    
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                    let URLRequest = NSURL(string: pictureURL)
                    let URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                    
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            let picture = PFFile(data: data!)
                            PFUser.currentUser()!.setObject(picture!, forKey: "profile_pic")
                            PFUser.currentUser()!.saveInBackground()
                        }
                        else {
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                    PFUser.currentUser()!.setValue(name, forKey: "username")
                    PFUser.currentUser()!.setValue(email, forKey: "email")
                    PFUser.currentUser()!["totalVotes"] = 0
                    PFUser.currentUser()!["posts"] = 0
                    PFUser.currentUser()!.saveInBackground()
                }
            }
        }
    }
    
    // MARK: - DZEmptyView
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No Recent Posts"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str,attributes: attrs);
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "It might have been a connection problems fronm the server or the internet connection is offline. Pull down to refresh. If the problem persits, try again later."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str,attributes: attrs);    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
        
    }
    
    // MARK: - PFLoginViewDelegate
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if username.characters.count != 0 && password.characters.count != 0 {
            return true
        }
        UIAlertView(title: "Missing Information", message: "Make sure you fill all the information!", delegate: nil, cancelButtonTitle: "OK").show()
        return false
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
      
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            //switched ! to ?
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user!.isNew {
                self.loadNewFaceookData()
                NSLog("User signed up and logged in through Facebook!")
                Answers.logLoginWithMethod("Facebook First Time Users",
                    success: true,
                    customAttributes: [:])
            } else {
                NSLog("User logged in through Facebook! \(user!.username)")
                Answers.logLoginWithMethod("Facebook Existing Users",
                    success: true,
                    customAttributes: [:])
              //  self.loadNewFaceookData()

                self.dismissViewControllerAnimated(true, completion: nil)

                
            }
        })
        
        Answers.logLoginWithMethod("Native Users",
                                   success: true,
                                   customAttributes: [:])
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        UIAlertView(title: "Username/Password Mismatched", message: "Username and password does not exist. Please check your credentials and try again.", delegate: nil, cancelButtonTitle: "OK").show()

        print("Failed to login...")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    
    // MARK: - PFSignupViewDelegate
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        let setUser = PFUser.currentUser()
        setUser!["totalVotes"] = 0
        setUser!["posts"] = 0
        Answers.logSignUpWithMethod("Native Users",
                                    success: true,
                                    customAttributes: [:])
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        let button2Alert: UIAlertView = UIAlertView(title: "Error!", message: "An error has occured. If this problem persists, please try again later",
                                                    delegate: nil, cancelButtonTitle: "Ok")
        button2Alert.show()
        
        print("Failed to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        print("User dismissed sign up.")
        
    }
    
    

    
    
    // MARK: - DZEmptyView Delegate
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true;
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return true;
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true;
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        //NSLog("", nil)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        // NSLog("", nil)
    }

    
     //MARK: - Facebook Login Setup if new user
    
    
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


