//
//  MyCell.swift
//  MyEvents
//
//  Created by Tianqi Chen on 5/10/16.
//  Copyright © 2016 Tianqi Chen. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date_var: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var calendar: UIImageView!
    @IBOutlet weak var loc: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
