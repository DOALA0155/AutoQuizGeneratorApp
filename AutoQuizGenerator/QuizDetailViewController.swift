//
//  QuizDetailViewController.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/08.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit

class QuizDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var quizData: Dictionary<String, Any> = [:]
    var quizAnswers: Array<String> = []
    var answerVisibilities: Array<Bool> = []
    
    @IBOutlet weak var quizSentenceView: UITextView!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizAnswersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitleLabel.text = (quizData["title"] as! String)
        quizSentenceView.text = (quizData["sentence"] as! String)
        quizAnswers = quizData["answers"] as! Array<String>
        
        quizAnswersTableView.delegate = self
        quizAnswersTableView.dataSource = self
        quizAnswersTableView.register(UINib(nibName: "QuizAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "QuizAnswerTableViewCell")
        
        for _ in 0..<(quizAnswers.count) {
            answerVisibilities.append(false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizAnswerTableViewCell") as! QuizAnswerTableViewCell
        let quizNumber = String(indexPath.row + 1)
        let quizAnswer = quizAnswers[indexPath.row]
        
        cell.quizAnswerLabel.text = quizAnswer
        cell.quizNumberLabel.text = quizNumber
        
        cell.answerSwitch.tag = indexPath.row
        cell.answerSwitch.addTarget(self, action: #selector(showAnswer), for: .valueChanged)
        
        if answerVisibilities[indexPath.row] == true {
            cell.quizAnswerLabel.isHidden = false
            cell.answerSwitch.isOn = true
        } else {
            cell.quizAnswerLabel.isHidden = true
            cell.answerSwitch.isOn = false
        }
        
        return cell
        
    }
    
    @objc func showAnswer(sender: UISwitch){
        let index = sender.tag
        
        if answerVisibilities[index] == true {
            answerVisibilities[index] = false
        } else {
            answerVisibilities[index] = true
        }
        quizAnswersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
