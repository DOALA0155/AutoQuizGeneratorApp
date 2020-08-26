//
//  QuizFavoritesTableViewCell.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/09.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit

class QuizFavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starButton.layer.masksToBounds = true
        starButton.layer.borderWidth = 1
        starButton.layer.borderColor = UIColor.black.cgColor
        starButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
