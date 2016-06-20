//
//  SearchTableViewController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 6/10/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Fabric
import Crashlytics
import MBProgressHUD
import DZNEmptyDataSet


class SearchTableViewController: PFQueryTableViewController, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    @IBOutlet weak var searchBar: UISearchBar!
    var HUD: MBProgressHUD?

    
    
    override func queryForTable() -> PFQuery {
        // Start the query object
        let query = PFQuery(className: "Questions")
        query.includeKey("postCreator")

        
        // Add a where clause if there is a search criteria
        if searchBar.text != "" {
            query.whereKey("question", containsString: searchBar.text!.lowercaseString)
            Answers.logSearchWithQuery(searchBar.text!.lowercaseString,
                                       customAttributes: [:])
        }
        
        // Order the results
        query.orderByAscending("createdAt")
        
        // Return the qwuery object
        return query
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    // MARK:- Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        
        // Delegate the search bar to this table view class
        searchBar.delegate = self
        
    }
    
    @IBAction func shareButton(sender: AnyObject){
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        
        let shareQuestion: String! = object?.objectForKey("question") as? String
        
        
        let shareText = "Question: \(shareQuestion) \n via Scenari"
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func answerAButton(sender: AnyObject){
        loadingHUD()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        let user = PFUser.currentUser()
        
        
        
        
        //This is where the key increment for the object
        //object!.saveInBackground()
        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                object!.addUniqueObject((user?.objectId)!, forKey: "answerVoted")
                object!.incrementKey("answer_a_total")

                PFUser.currentUser()!.incrementKey("totalVotes")

                Answers.logCustomEventWithName("Answer A Votes - Total",
                    customAttributes: [:])
                
                self.doneHUD()
                print("Success")
            } else {
                
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Your vote cannot be submitted. Please check your infomation and try again.", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        object!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                object!.addUniqueObject((user?.objectId)!, forKey: "answerVoted")
 
                object!.incrementKey("answer_b_total")
                PFUser.currentUser()!.incrementKey("totalVotes")

                
                Answers.logCustomEventWithName("Answer B Votes - Total",
                    customAttributes: [:])
                
                // The object has been saved.
                self.doneHUD()
                self.HUD!.hide(true)
                
                print("Success")
            } else {
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Your vote cannot be submitted. Please check your infomation and try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.HUD!.hide(true)
                print("Failure")
            }
            
            
        }
        
        self.tableView.reloadData()
        NSLog("Top Index Path \(hitIndex?.row)")
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchTableCell
        
        
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

    // MARK: - DZEmptyView
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No Data"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        //let font = UIFont(name: "akaDora", size: 60)
        
        return NSAttributedString(string: str,attributes: attrs);
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "You can search for a scenario with any releated items."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str,attributes: attrs);    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
        
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        return UIImage(named: "Search-EmptyView.png")!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
