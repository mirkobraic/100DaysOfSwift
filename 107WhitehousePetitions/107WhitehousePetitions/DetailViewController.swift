//
//  DetailViewController.swift
//  107WhitehousePetitions
//
//  Created by Mirko Braic on 21/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedCount = formatter.string(for: detailItem.signatureCount) ?? "\(detailItem.signatureCount)"
        title = "\(formattedCount) signatures"
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 130%; font-family: Verdana; } </style>
        </head>
        <body>
        <h3>
        \(detailItem.title.htmlDecoded())
        </h3>
        \(detailItem.body.htmlDecoded())
        </body>
        </hmtl>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
