//
//  StudentListCell.swift
//  ChildrenTrackingSystem
//
//  Created by Bubble on 11/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit

class ChildListCell: UITableViewCell {

    @IBOutlet weak var profileChildName: UILabel!
    @IBOutlet weak var profileChildEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
