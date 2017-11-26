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
        historyWebView.backgroundColor = UIColor.red
    }

    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
