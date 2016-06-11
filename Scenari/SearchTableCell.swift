//
//  SearchTableCell.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 6/10/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Fabric

class SearchTableCell: PFTableViewCell {

    @IBOutlet weak var profilePic:PFImageView!
    @IBOutlet weak var userPostLabel: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerAcount: UILabel!
    @IBOutlet weak var answerBcount: UILabel!
    
    //var parseObjectString: NSString!
    
    var parseObject:PFObject!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true;
        
        */
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
