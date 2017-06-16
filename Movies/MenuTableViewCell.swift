//
//  MenuTableViewCell.swift
//  Movies
//
//  Created by Khalis on 16/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var genreLabel: UILabel!     //Name of the genres
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
