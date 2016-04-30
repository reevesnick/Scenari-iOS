//
//  ScenarioPostDetailViewController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 4/29/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ScenarioPostDetailViewController: UIViewController {
    
    //@IBOutlet weak var usernameString: UILabel!
    @IBOutlet weak var questionString: UILabel!
    @IBOutlet weak var answerAString: UILabel!
    @IBOutlet weak var answerBString: UILabel!
    
    //var usernameStringParse: String!
    var questionStringParse: String!
    var answerAStringParse:String!
    var answerBStringParse: String!
    var objectID: PFObject!
    
   // var pictureFile: PFFile!


   // @IBOutlet  var candidatePictureFile: PFImageView!
    //@IBOutlet weak var candidateWebsite: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // self.usernameString.text =  usernameStringParse
        self.questionString.text = questionStringParse
        self.answerAString.text = answerAStringParse
        self.answerBString.text = answerBStringParse

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func answerAButton(sender: UIButton){
        let user = PFUser.currentUser()
        //let answerObj = PFObject(className: "Questions")
      //  answerObj["answerAArray"] = user?.objectId;
        object.addUniqueObject((user?.objectId)!, forKey: "answerA_array")
        
        object.saveInBackgroundWithBlock {
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
        let answerObj = PFObject()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
