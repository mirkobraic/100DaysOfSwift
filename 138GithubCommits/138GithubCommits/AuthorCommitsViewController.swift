//
//  AuthorCommitsViewController.swift
//  138GithubCommits
//
//  Created by Mirko Braic on 15/05/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit
import CoreData

class AuthorCommitsViewController: UITableViewController {
//    var container: NSPersistentContainer!
    var commits = [Commit]()
    
    var author: Author!
    var selectedCommit: Commit?
    var setDetailCommit: ((Commit) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(author != nil, "Author needs to be provided!")
        
        title = "All commits"
        
//        container = NSPersistentContainer(name: "Project38")
//        container.loadPersistentStores { storeDescription, error in
//            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//
//            if let error = error {
//                // something has gone fatally wrong
//                print("Unresolved error: \(error)")
//            }
//        }
        
        loadCommits()
    }
    
    private func loadCommits() {
        let request = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "author.name == %@", author.name)
        
        do {
//            commits = try container.viewContext.fetch(request)
            commits = try CoreDataManager.shared.fetch(request)
            print("Got \(commits.count) commits")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let commit = commits[indexPath.row]
        cell.textLabel?.text = commit.message
        cell.detailTextLabel!.text = "By \(commit.author.name) on \(commit.date.description)"
        if commit.sha == selectedCommit?.sha {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCommit = commits[indexPath.row]
        setDetailCommit?(selectedCommit!)
        dismiss(animated: true)
    }
}
