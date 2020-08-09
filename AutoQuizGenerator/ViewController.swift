//
//  ViewController.swift
//  AutoQuizGenerator
//
//  Created by 勝山翔紀 on 2020/08/07.
//  Copyright © 2020 勝山翔紀. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    var quizData: Dictionary<String, Any> = [:]
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateButton.layer.cornerRadius = 25
    }
    
    @IBAction func generateQuiz(_ sender: Any) {
        let word = wordTextField.text!
        
        if word == "" {
            let alert = UIAlertController(title: "Generate Error", message: "Please enter something when you generate a quiz.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            generateButton.isEnabled = false
            generateButton.setTitle("Generating Quiz...", for: .normal)
            
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
                        self.quizData = self.convertToDictionary(text: apiData as String)!
                        
                        self.generateButton.isEnabled = true
                        self.generateButton.setTitle("Generate", for: .normal)
                        self.wordTextField.text = ""
                        
                        self.performSegue(withIdentifier: "toQuizDetail", sender: nil)
                    } else {
                        print(error.debugDescription)
                    }
                }
            }.resume()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
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
}

