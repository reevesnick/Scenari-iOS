//
//  MessagesViewController.swift
//  Scenari Messenger
//
//  Created by Neegbeah Reeves on 10/13/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Messages

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class MessagesViewController: MSMessagesAppViewController, UITextFieldDelegate {
    
    @IBOutlet var inputQuestion: UITextField!
    @IBOutlet var characterCount: UILabel!
    @IBOutlet var questionPreivew: UILabel!
    @IBOutlet var imageViewLayout: UIView!
    @IBOutlet var scenariLogo: UIImageView!
    @IBOutlet var sloganLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //questionPreivew.text = "\(inputQuestion.text!)";
        questionPreivew.text = "Write a scenario."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generateButton(_:AnyObject){
        let str = inputQuestion.text
        questionPreivew!.text = "\(str!)";

    
        
        
    }
    
    func createImageForMessage() -> UIImage? {
       let str = inputQuestion.text
        
        //let background = imageViewLayout
        
        

        
        let background = UIView(frame: CGRect(x: 5, y: 0, width: 300, height: 300))
        background.backgroundColor = UIColor(red: 82, green: 167, blue: 223)
        /*
        let label = UILabel(frame: CGRect(x: 75, y: 75, width: 150, height: 150))
        label.font = UIFont.init(name: "Avenir", size: 17.5)
        label.backgroundColor = UIColor.blueColor()
        label.textColor = UIColor.whiteColor()
        label.text = "\(str!)"
        label.layer.cornerRadius = label.frame.size.width/2.0
        label.clipsToBounds = true
        */
        
        questionPreivew = UILabel(frame: CGRect(x: 0, y: 65, width: 289, height: 115))
        questionPreivew.font = UIFont.init(name: "Avenir", size: 22)
        questionPreivew.textColor = UIColor.whiteColor()
        questionPreivew.text = "\(str!)"
        questionPreivew.numberOfLines = 0
  
        questionPreivew.clipsToBounds = true
        
        scenariLogo = UIImageView(frame: CGRect(x:190, y:235, width: 98, height: 43))
        let imagePlace = UIImage(named: "Scenari_Login_Logo.png");
        scenariLogo.image = imagePlace
        
        sloganLabel = UILabel(frame: CGRect(x:195, y:260, width: 98, height: 43))
        sloganLabel.font = UIFont.init(name: "Avenir Book", size: 11)
        sloganLabel.textColor = UIColor.whiteColor()
        sloganLabel.text = "What will you do?"
        //sloganLabel.layer.cornerRadius = sloganLabel.frame.size.width/2.0
        sloganLabel.clipsToBounds = true
        
        
        background.addSubview(questionPreivew!)
        background.addSubview(scenariLogo!)
        background.addSubview(sloganLabel!)
        
        background.frame.origin = CGPoint(x: view.frame.size.width, y: view.frame.size.height)
        view.addSubview(background)
        
        
        UIGraphicsBeginImageContextWithOptions(background.frame.size, false, UIScreen.mainScreen().scale)
        background.drawViewHierarchyInRect(background.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        background.removeFromSuperview()
        
        
        return image
    }
    @IBAction func sendButton(_: AnyObject){
       if let image = createImageForMessage(), let conversation = activeConversation {
            let layout = MSMessageTemplateLayout()
            layout.image = image
            layout.caption = "Created via Scenari"
            
            let message = MSMessage()
            message.layout = layout
            message.URL = NSURL(string: "emptyURL")

        
        
          
        conversation.insertMessage(message, completionHandler: { (error: NSError?) in
            print(error)
        
        })
        }
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
       // let stringplace: String = inputQuestion.text!;
        questionPreivew.text = "\(inputQuestion.text!)";
        inputQuestion.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Conversation Handling
    
     func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
     func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
     func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
     func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
     func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
     func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
     func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
