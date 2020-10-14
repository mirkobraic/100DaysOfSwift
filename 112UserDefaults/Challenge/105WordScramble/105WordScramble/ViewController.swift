//
//  ViewController.swift
//  105WordScramble
//
//  Created by Mirko Braic on 19/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        usedWords = UserDefaults.standard.object(forKey: "usedWords") as? [String] ?? []
        if let mainWord = UserDefaults.standard.string(forKey: "mainWord") {
            title = mainWord
        } else {
            startGame()
        }
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        saveTitle()
        usedWords.removeAll(keepingCapacity: true)
        saveUsedWords()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let word = usedWords[indexPath.row]
        let ref = UIReferenceLibraryViewController(term: word)
        present(ref, animated: true, completion: nil)
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    saveUsedWords()
                    
                    // indexPath must match the position of a new element in the array
                    let indexPath = IndexPath(row: 0, section: 0)
                    // it is better to add new cell like this than to reload whole tableView
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(title: "Word already used", message: "Be more original!")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title.lowercased()).")
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        guard word.count >= 2 else { return false }
        
        let checker = UITextChecker()
        // UITextChecker is not good with swift strings, objective c uses utf16. Sometimes word.count and word.utf16.count may return different values. For example: swift stores emojies as one characther but in utf16 they might be two characters. Rule of thumb: when working with apple frameworks (UIKit, SpriteKit) use utf16.count, otherwise use .count
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func saveTitle() {
        UserDefaults.standard.set(title, forKey: "mainWord")
    }
    
    func saveUsedWords() {
        UserDefaults.standard.set(usedWords, forKey: "usedWords")
    }
}

