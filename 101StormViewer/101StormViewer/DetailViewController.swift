//
//  DetailViewController.swift
//  101StormViewer
//
//  Created by Mirko Braic on 12/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // strong and weak outlet are basically same
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var pictureCount = 0
    var selectedPictureNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(selectedPictureNumber) of \(pictureCount)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
