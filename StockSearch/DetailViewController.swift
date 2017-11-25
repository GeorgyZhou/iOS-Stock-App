//
//  DetailViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/22/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var currentView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var ticker: String = ""
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func switchCurrentView() -> Void {
        self.newsView.isHidden = true
        self.historyView.isHidden = true
        self.currentView.isHidden = false
    }
    
    func switchHistoryView() -> Void {
        self.newsView.isHidden = true
        self.currentView.isHidden = true
        self.historyView.isHidden = false
    }
    
    func switchNewsView() -> Void {
        self.currentView.isHidden = true
        self.historyView.isHidden = true
        self.newsView.isHidden = false
    }
    
    func loadData() -> Void {
        let currentControllers = self.childViewControllers[0]
        let historicalControllers = self.childViewControllers[1]
        let 
    }
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchCurrentView()
        self.view.addSubview(self.currentView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
