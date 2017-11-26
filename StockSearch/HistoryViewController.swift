//
//  HistoryViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/25/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit

class HistoryViewController : UIViewController {
    
    @IBOutlet weak var historyWebView: UIWebView!
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func initView() -> Void {
        /** guard let url = Bundle.main.url(forResource: "webview/indicators", withExtension: "html") else {
            print("indicators.html loading failed")
            return
        }
        let request = URLRequest(url: url)
        self.historyWebView.loadRequest(request)**/
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
