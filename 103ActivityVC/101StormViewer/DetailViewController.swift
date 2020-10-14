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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
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
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8),
            let imageName = selectedImage else {
                print("No image found")
                return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        // without this line code will crash on iPad because UIActivityViewController must be shown form somewhere on the screen so a little arrow can appear
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
