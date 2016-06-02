//
//  ProfileCell.swift
//  Scenari
//
//  Created by Neegbeah Reeves on 5/31/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell: PFTableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerAcount: UILabel!
    @IBOutlet weak var answerBcount: UILabel!
    
    var parseObject:PFObject!


}
