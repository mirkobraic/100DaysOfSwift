//
//  ViewController.swift
//  101StormViewer
//
//  Created by Mirko Braic on 11/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var pictureShownCounter = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        // some app bundles may not have resource path but all iOS apps must have a valid resource path for its bundle
        let path = Bundle.main.resourcePath!
        // if we cannot read the contents of our app bundle something is fundementally broken in our app
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        
        let defaults = UserDefaults.standard
        if let savedCounter = defaults.object(forKey: "pictureCounter") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictureShownCounter = try jsonDecoder.decode([String: Int].self, from: savedCounter)
            } catch {
                print("Failed to load picture counter.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Shown \(pictureShownCounter[pictures[indexPath.row], default: 0]) times"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let imageName = pictures[indexPath.row]
            vc.selectedImage = imageName
            vc.pictureCount = pictures.count
            vc.selectedPictureNumber = indexPath.row + 1
            pictureShownCounter[imageName, default: 0] += 1
            tableView.reloadRows(at: [indexPath], with: .automatic)
            savePictureCounter()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func savePictureCounter() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictureShownCounter) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictureCounter")
        } else {
            print("Failed to save picture counter.")
        }
    }
}

