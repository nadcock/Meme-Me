//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Nick Adcock on 7/20/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellLabel.sizeToFit()
        cellLabel.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
