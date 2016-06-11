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
import MBProgressHUD
import Fabric
import Crashlytics

class CreateScenarioViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var questionScenario:UITextView!
    @IBOutlet weak var answerAField: UITextField!
    @IBOutlet weak var answerBField: UITextField!
    
    var HUD:MBProgressHUD?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionScenario.delegate = self;
        answerAField.delegate = self;
        answerBField.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIButton){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(sender: AnyObject){
        loadingHUD()
        let questionText = questionScenario.text
        let answerAText = answerAField.text
        let answerBText = answerBField.text
        
        let posts = PFObject(className: "Questions")
        posts["question"] = questionText
        posts["answer_a"] = "A: "+answerAText!
        posts["answer_b"] = "B: "+answerBText!
        posts["answer_a_total"] = 0
        posts["answer_b_total"] = 0
        posts["postCreator"] = PFUser.currentUser()
        PFUser.currentUser()?.incrementKey("posts")

        
       
        
        posts.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                PFUser.currentUser()?.incrementKey("posts")
                self.doneHUD()
                print("Success")
                
                Answers.logCustomEventWithName("Posts - Total",
                    customAttributes: [:])
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                if (questionText.isEmpty && (answerAText?.isEmpty)! && (answerBText?.isEmpty)!){
                    let alert = UIAlertController(title: "Error", message: "Please fill out every blank before submitting.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.HUD!.hide(true)
                    print("Fields Empty")
                    //loadingBar.hide(true)
                }

                
                
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Your scenario cannot be submitted. Please check your infomation and try again. Error message: "+(error?.description)!, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.HUD!.hide(true)
                print("Failure")
            }
        }
    }
    
    //MARK - MBProgressHUD Customization
    func doneHUD(){
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD!.customView = UIImageView(image: UIImage(named: "Checkmark.png"))
        
        // Set custom view mode
        HUD!.mode = .CustomView;
        
        //HUD!.delegate = self;
        HUD!.labelText = "Scenario Submitted";
        
        HUD!.show(true)
        HUD!.hide(true, afterDelay:3)
    }
    
    func loadingHUD(){
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        //HUD!.delegate = self
        HUD!.labelText = "Submitting..."
        
    }
    
    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        questionScenario.resignFirstResponder()
        answerAField.resignFirstResponder()
        answerBField.resignFirstResponder()
        return true

    }
    
    // MARK: - UITextView Delegares
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            questionScenario.resignFirstResponder()
            return false
        }
        return true
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
