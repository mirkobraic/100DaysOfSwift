//
//  ViewController.swift
//  102GuessTheFlag
//
//  Created by Mirko Braic on 13/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0 {
        didSet {
            navigationItem.prompt = "Score: \(score)"
        }
    }
    var correctAnswer = 0
    var questionCount = 0
    let questionLimit = 5
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.prompt = "Score: \(score)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        highScore = UserDefaults.standard.object(forKey: "highScore") as? Int ?? -questionLimit
        
        askQuestion()
    }
    
    func askQuestion() {
        questionCount += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String?
        
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct"
            message = nil
        } else {
            score -= 1
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag])"
        }
        
        if self.questionCount >= self.questionLimit {
            finishGame()
        } else {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default) { _ in
                self.askQuestion()
            })
            present(ac, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["This app is my favorite", URL(string: "https://www.apple.com")!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func finishGame() {
        var finishMessage: String
        if score > highScore {
            finishMessage = "You beat your high score of \(highScore). Your final score is \(score)"
            highScore = score
            UserDefaults.standard.set(score, forKey: "highScore")
        } else {
            finishMessage = "Your final score is \(score)"
        }
        let finishAc = UIAlertController(title: "Congratulations", message: finishMessage, preferredStyle: .alert)
        finishAc.addAction(UIAlertAction(title: "Restart", style: .destructive) { _ in
            self.questionCount = 0
            self.score = 0
            self.askQuestion()
        })
        present(finishAc, animated: true)
    }
}

