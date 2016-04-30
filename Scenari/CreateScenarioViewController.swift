//
//  CreateScenarioViewController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 4/29/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CreateScenarioViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionScenario:UITextView!
    @IBOutlet weak var answerAField: UITextField!
    @IBOutlet weak var answerBField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButton(sender: AnyObject){
        let questionText = questionScenario.text
        let answerAText = answerAField.text
        let answerBText = answerAField.text
        
        let posts = PFObject(className: "Questions")
        posts["question"] = questionText
        posts["answer_a"] = answerAText
        posts["answer_b"] = answerBText
        posts["postCreator"] = PFUser.currentUser()
        
        posts.saveInBackgroundWithBlock {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
