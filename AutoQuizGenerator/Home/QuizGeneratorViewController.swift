//
//  QuizGeneratorViewController.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/07.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit
import Foundation

class QuizGeneratorViewController: UIViewController, UITextFieldDelegate {

    var quizData: Dictionary<String, Any> = [:]
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateButton.layer.cornerRadius = 25
        wordTextField.delegate = self
    }
    
    @IBAction func generateQuiz(_ sender: Any) {
        let word = wordTextField.text!
        wordTextField.endEditing(true)
        
        if word == "" {
            let alert = UIAlertController(title: "Generate Error", message: "Please enter something when you generate a quiz.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            generateButton.isEnabled = false
            generateButton.setTitle("生成中", for: .normal)
            
            let url = URL(string: "https://quiz-generator-api.herokuapp.com/generate")!
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

            let parameter = ["word": word]
            request.httpBody = try! JSONEncoder().encode(parameter)

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if data != nil {
                        let apiData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                        
                        if apiData.contains("Internal Server Error") {
                            
                            let alert = UIAlertController(title: "Generate Error", message: "Please enter something when you generate a quiz.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            
                            self.generateButton.isEnabled = true
                            self.generateButton.setTitle("Generate", for: .normal)
                            self.wordTextField.text = ""
                            
                        } else {
                            self.quizData = self.convertToDictionary(text: apiData as String)!
                            
                            self.generateButton.isEnabled = true
                            self.generateButton.setTitle("Generate", for: .normal)
                            self.wordTextField.text = ""
                            
                            var history = UserDefaults.standard.array(forKey: "history")
                            
                            if history == nil {
                                var historyList = [] as! Array<Dictionary<String, Any>>
                                self.quizData["index"] = 0
                                historyList.append(self.quizData)
                                UserDefaults.standard.set(historyList, forKey: "history")
                            } else {
                                self.quizData["index"] = history?.count
                                history!.append(self.quizData)
                                UserDefaults.standard.set(history, forKey: "history")
                            }
                            
                            self.performSegue(withIdentifier: "toQuizDetail", sender: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Generate Error", message: "Please enter something when you generate a quiz.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        self.generateButton.isEnabled = true
                        self.generateButton.setTitle("Generate", for: .normal)
                        self.wordTextField.text = ""                    }
                }
            }.resume()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                let alert = UIAlertController(title: "Generate Error", message: "Please enter something when you generate a quiz.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizDetail" {
            let QuizDetailView = segue.destination as! QuizDetailViewController
            QuizDetailView.quizData = self.quizData
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

