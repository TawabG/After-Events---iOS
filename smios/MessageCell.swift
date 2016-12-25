//
//  MessageCell.swift
//  smios
//
//  Created by Fhict on 22/12/2016.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit
import Foundation

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reaction: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
