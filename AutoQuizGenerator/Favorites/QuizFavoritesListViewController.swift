//
//  QuizFavoritesListViewController.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/09.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit

class QuizFavoritesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var starList: Array<Dictionary<String, Any>> = []
    
    @IBOutlet weak var starListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starListTableView.delegate = self
        starListTableView.dataSource = self
        starListTableView.register(UINib(nibName: "QuizFavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "QuizFavoritesTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        starList = []
        
        if UserDefaults.standard.array(forKey: "history") != nil {
            let historyList = UserDefaults.standard.array(forKey: "history") as! Array<Dictionary<String, Any>>
            for history in historyList {
                if (history["stared"] as! Int) == 1 {
                    starList.append(history)
                }
            }
            starListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizFavoritesTableViewCell") as! QuizFavoritesTableViewCell
        let star = starList[indexPath.row]
        
        cell.starButton.backgroundColor = UIColor.yellow
        
        cell.wordLabel.text = (star["title"] as! String)
        cell.starButton.addTarget(self, action: #selector(starQuiz), for: .touchUpInside)
        cell.starButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func starQuiz(sender: UIButton) {
        let index = sender.tag
        
        starList[index]["stared"] = 0
        var historyList = UserDefaults.standard.array(forKey: "history") as! Array<Dictionary<String, Any>>
        
        for star in starList {
            let historyIndex = star["index"]
            historyList[historyIndex as! Int] = star
        }
        starList.remove(at: index)
        UserDefaults.standard.set(historyList, forKey: "history")
        starListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizData = starList[indexPath.row]
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
