//
//  LoginView.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 6/3/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//
import Foundation
import Parse
import ParseUI

class LoginView: PFLogInViewController {
    
    var backgroundImage : UIImageView!;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "login_background_image"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        /*
        // remove the parse Logo using image
        let logoView = UIImageView(image: UIImage(named:"Scenari_Login_Logo.png"))
        logoView.frame = CGRect(x: 0 ,y: 0, width: 173.0, height: 72)
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        self.logInView!.logo = logoView
        */
        
        // remove the parse Logo using typefont
        

        let logo = UILabel()
        logo.text = "Scenari"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "akaDora", size: 60)
        //logo.shadowColor = UIColor.lightGrayColor()
        //logo.shadowOffset = CGSizeMake(2, 2)
        logInView?.logo = logo
        
        // position logo at top with larger frame
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        
        // set forgotten password button to white
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // make the background of the login button pop more
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        
        // make the buttons classier
       customizeButton(logInView?.facebookButton!)
    //customizeButton(logInView?.twitterButton!)
        customizeButton(logInView?.signUpButton!)
        //customizeButton(logInView?.logInButton!)
        //customizeButton(logInView?.passwordForgottenButton!)

        

    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        //backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
    }


}
