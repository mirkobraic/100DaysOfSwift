//
//  DetailViewController.swift
//  138GithubCommits
//
//  Created by Mirko Braic on 14/05/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var detailItem: Commit!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.scrollView.contentInset.top = 40
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(detailItem != nil, "Detail item needs to be provided")
        
        addStatusBarBlur()
        setupToolbar()
        title = detailItem.author.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commits", style: .plain, target: self, action: #selector(showAuthorCommits))
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        loadUrl(string: detailItem.url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func addStatusBarBlur() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, back, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    private func loadUrl(string: String) {
        guard let url = URL(string: detailItem.url) else { return }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func showAuthorCommits() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authorVC = storyboard.instantiateViewController(identifier: "AuthorCommitsViewController") as! AuthorCommitsViewController
        
        authorVC.author = detailItem.author
        authorVC.selectedCommit = detailItem
        authorVC.setDetailCommit = { [weak self] commit in
            self?.detailItem = commit
            self?.loadUrl(string: commit.url)
        }
        
        present(authorVC, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
