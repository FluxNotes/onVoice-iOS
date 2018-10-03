//
//  WebViewController.swift
//  FluxNotes
//
//  Created by Horn III, Robert E on 8/17/18.
//  Copyright © 2018 Robert Horn. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://fluxnotes.org/demo2") {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
