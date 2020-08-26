//
//  QuizHistoryListViewController.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/09.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit

class QuizHistoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyListTableView: UITableView!
    
    var historyList: Array<Dictionary<String, Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyListTableView.delegate = self
        historyListTableView.dataSource = self
        historyListTableView.register(UINib(nibName: "QuizHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "QuizHistoryTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if UserDefaults.standard.array(forKey: "history") != nil {
            historyList = UserDefaults.standard.array(forKey: "history") as! Array<Dictionary<String, Any>>
            historyListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizHistoryTableViewCell") as! QuizHistoryTableViewCell
        let history = historyList[indexPath.row]
        
        if (history["stared"] as! Int) == 1 {
            cell.starButton.backgroundColor = UIColor.yellow
        } else {
            cell.starButton.backgroundColor = UIColor.white
        }
        
        cell.wordLabel.text = (history["title"] as! String)
        cell.starButton.addTarget(self, action: #selector(starQuiz), for: .touchUpInside)
        cell.starButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func starQuiz(sender: UIButton) {
        let index = sender.tag
        
        if (historyList[index]["stared"] as! Int) == 1 {
            historyList[index]["stared"] = 0
        } else {
            historyList[index]["stared"] = 1
        }
        
        UserDefaults.standard.set(historyList, forKey: "history")
        historyListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizData = historyList[indexPath.row]
        self.performSegue(withIdentifier: "toQuizDetail", sender: quizData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizDetail" {
            let QuizDetailView = segue.destination as! QuizDetailViewController
            QuizDetailView.quizData = sender as! Dictionary<String, Any>
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
