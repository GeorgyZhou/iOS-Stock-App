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
        // let currentController = self.childViewControllers[0]
        // let historyController = self.childViewControllers[1]
        // let newsController = self.childViewControllers[2]
        
    }
    
    func loadQuote() -> Void {
        if ticker.characters.count < 0 { return }
        let quoteUrl = "http://ec2-18-221-164-179.us-east-2.compute.amazonaws.com/api/quote?symbol=" + ticker
        let currentController = self.childViewControllers[0] as! CurrentViewController
        Alamofire.request(quoteUrl).responseSwiftyJSON { response in
            if response.result.isSuccess, let json = response.result.value {
                currentController.onTableDataLoaded(data: json)
            } else if let error = response.error {
                print (error)
            }
        }
    }
    
    func loadNews() -> Void {
        if ticker.characters.count < 0 { return }
        let newsUrl = "http://ec2-18-221-164-179.us-east-2.compute.amazonaws.com/api/news?symbol=" + ticker
        let newsViewController = self.childViewControllers[1] as! NewsViewController
        Alamofire.request(newsUrl).responseSwiftyJSON { response in
            if response.result.isSuccess, let json = response.result.value {
                newsViewController.onNewsDataLoaded(data: json)
            } else {
                print(response.error!)
            }
        }
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
