//
//  ViewController.swift
//  107WhitehousePetitions
//
//  Created by Mirko Braic on 21/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petititons = [Petition]()
    var filteredPetitions = [Petition]()
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        
        fetchJSON()
    }
    
    func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            // "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            // "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            
            self?.performSelector(onMainThread: #selector(self?.showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func search() {
        let ac = UIAlertController(title: "Enter search text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = searchText
        ac.addAction(UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] action in
            guard let self = self else { return }
            guard let ac = ac else { return }
            
            if let text = ac.textFields?[0].text {
                DispatchQueue.global(qos: .userInitiated).async {
                    let searchText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    self.filteredPetitions = self.petititons.filter {
                        $0.title.lowercased().contains(searchText) || $0.body.lowercased().contains(searchText)
                    }
                    self.searchText = searchText
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        })
        ac.addAction(UIAlertAction(title: "Dismiss", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.filteredPetitions = self.petititons
            self.searchText = ""
            self.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petititons = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

