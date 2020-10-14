//
//  DetailViewController.swift
//  138CoreDataTest
//
//  Created by Mirko Braic on 15/05/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let scene = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
//        guard let splitViewController = scene.window!.rootViewController as? UISplitViewController else { return }
//        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        configureView()
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

