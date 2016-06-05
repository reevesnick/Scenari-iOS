//
//  SignupView.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 6/3/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class SignupView: PFSignUpViewController {
    
    var backgroundImage : UIImageView!;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "login_background_image"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.signUpView!.insertSubview(backgroundImage, atIndex: 0)
     
        let logo = UILabel()
        logo.text = "Scenari"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "akaDora", size: 60)
        //logo.shadowColor = UIColor.lightGrayColor()
        //logo.shadowOffset = CGSizeMake(2, 2)
        signUpView?.logo = logo
        
  

        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        //backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
    }

}
