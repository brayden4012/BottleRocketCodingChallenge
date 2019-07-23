//
//  InternetsViewController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/19/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit
import WebKit

class InternetsViewController: UIViewController {
    
    // MARK: - Properties
    let navItem = UINavigationItem(title: "")
    let navigationBar = UINavigationBar()
    let backButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(backButtonTapped))
    let refreshButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(refreshButtonTapped))
    let nextButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(nextButtonTapped))
    let webView = WKWebView()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 67/255, green: 232/255, blue: 149/255, alpha: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupBackButton()
        setupRefreshButton()
        setupNextButton()
        setupNavBar()
        setupWebView()
    }
    
    func setupBackButton() {
        backButton.image = #imageLiteral(resourceName: "ic_webBack")
        backButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setupRefreshButton() {
        refreshButton.image = #imageLiteral(resourceName: "ic_webRefresh")
        refreshButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setupNextButton() {
        nextButton.image = #imageLiteral(resourceName: "ic_webForward")
        nextButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setupNavBar() {
        navigationBar.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: 44)
        
        self.view.addSubview(navigationBar)
        navigationBar.barTintColor = UIColor(red: 67/255, green: 232/255, blue: 149/255, alpha: 1)
        navigationBar.isTranslucent = false
        
        navItem.setLeftBarButtonItems([backButton, refreshButton, nextButton], animated: false)
        navigationBar.items = [navItem]
    }
    
    func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
        guard let url = URL(string: "https://www.bottlerocketstudios.com") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // Action Methods
    @objc func backButtonTapped() {
        webView.goBack()
    }
    
    @objc func refreshButtonTapped() {
        webView.reload()
    }
    
    @objc func nextButtonTapped() {
        webView.goForward()
    }
}
