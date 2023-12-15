//
//  ListTableViewCell.swift
//  CocktailBook
//
//  Created by Prameela Akkinapalli on 12/12/23.
//  Copyright © 2023 Prameela Akkinapalli. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var shortDesc: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
