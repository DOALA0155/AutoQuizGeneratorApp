//
//  QuizAnswerTableViewCell.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/09.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit

class QuizAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var quizAnswerLabel: UILabel!
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var answerSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
