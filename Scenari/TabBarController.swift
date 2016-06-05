//
//  TabBarController.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 6/5/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabs:[UITabBarItem] = self.tabBar.items{
            let post: UITabBarItem = tabs[0] as UITabBarItem
            let profile: UITabBarItem = tabs[1] as UITabBarItem
            
            post.image = UIImage(named: "post")
            profile.image = UIImage(named: "profile")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
