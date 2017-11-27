//
//  HistoryViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/25/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit

class HistoryViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var historyWebView: UIWebView!
    @IBOutlet weak var waitSpinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabelView: UILabel!
    
    var ticker = ""
    var checkTimer : Timer?
    
    /** --------------------------   WebView Implementation    -------------------------- **/
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadWebViewChart()
    }
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func initView() -> Void {
        self.errorLabelView.isHidden = true
        
        self.historyWebView.isOpaque = false
        self.historyWebView.backgroundColor = UIColor.clear
        self.historyWebView.scrollView.isScrollEnabled = false
        self.historyWebView.delegate = self;
        
        self.loadWebView()
    }
    
    func onError() {
        self.errorLabelView.isHidden = false
        self.historyWebView.isHidden = true
    }
    
    func startTimer() -> Void {
        self.checkTimer?.invalidate()
        self.checkTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HistoryViewController.checkChartStatus), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void {
        self.checkTimer?.invalidate()
    }

    func loadWebView() -> Void {
        guard let url = Bundle.main.url(forResource: "webview/history", withExtension: "html") else {
            print("history.html loading failed")
            return
        }
        let request = URLRequest(url: url)
        print(url)
        self.historyWebView.loadRequest(request)
    }
    
    func loadWebViewChart() {
        self.waitSpinner.startAnimating()
        self.startTimer()
        let callFunc = "loader('\(self.ticker)')"
        print(callFunc)
        self.historyWebView.stringByEvaluatingJavaScript(from: callFunc)
    }
    
    @objc func checkChartStatus() {
        let status = self.historyWebView.stringByEvaluatingJavaScript(from: "checkChartStatus()")
        if status == nil || status == "" || status == "No" {
            print("still loading....")
        } else {
            self.waitSpinner.stopAnimating()
            self.stopTimer()
            if self.checkError() {
                self.onError()
            } else {
                print("Finish Loading")
                self.resizeWebViewHeight()
            }
        }
    }
    
    func resizeWebViewHeight() {
        var newBounds = self.historyWebView.bounds
        newBounds.size.height = self.historyWebView.scrollView.contentSize.height
        self.historyWebView.bounds = newBounds
    }

    func checkError() -> Bool {
        let status = self.historyWebView.stringByEvaluatingJavaScript(from: "checkError();")
        if status == nil || status == "Yes" {
            return true
        } else {
            return false
        }
    }
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
