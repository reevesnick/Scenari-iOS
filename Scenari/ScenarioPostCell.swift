//
//  ScenarioPostCell.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 4/29/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ScenarioPostCell: PFTableViewCell {
    
    //@IBOutlet weak var profilePic:PFImageView!
    @IBOutlet weak var userPostLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerAcount: UILabel!
    @IBOutlet weak var answerBcount: UILabel!
    
    var parseObjectString: NSString!
    
    var parseObject:PFObject!
    
    
    
    @IBAction func answerAButton(sender: UIButton){
        
        if(parseObject != nil) {
            if var votes:Int? = parseObject!.objectForKey("answer_1_total") as? Int {
                votes!++
                
                parseObject!.setObject(votes!, forKey: "answer_1_total");
                parseObject!.saveInBackground();
            }
        }
       /*
        let user = PFUser.currentUser()
        let answerObj = PFObject(className: "Questions")
        answerObj.setObject(parseObject, forKey: "objectId")
        
        //  answerObj["answerAArray"] = user?.objectId;
        answerObj.addUniqueObject((user?.objectId)!, forKey: "answerA_array")
        
        answerObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Success")
            } else {
                // There was a problem, check error.description
                print("Failure"+(error?.description)!)
            }
        }
        */
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


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        //profilePic.clipsToBounds = true;
        
    }
    /// override func view
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
