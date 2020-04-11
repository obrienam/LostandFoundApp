//
//  TableViewCell.swift
//  LostandFoundApp
//
//  Created by Aidan O'Brien on 4/11/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
