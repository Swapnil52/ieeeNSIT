//
//  ieeeNoImageFeedCell.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 13/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class ieeeNoImageFeedCell: UITableViewCell {
    
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
