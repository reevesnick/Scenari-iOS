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

class SearchTableViewController: PFQueryTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
