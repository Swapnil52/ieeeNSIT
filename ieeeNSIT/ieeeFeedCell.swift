//
//  ieeeFeedCell.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 13/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class ieeeFeedCell: UITableViewCell {
    
    @IBOutlet var paddingView: UIView!
    @IBOutlet var img: UIImageView!
    @IBOutlet var message: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var likes: UILabel!
    @IBOutlet var shadowView: UIView!
    
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
