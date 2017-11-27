//
//  NewsViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/25/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var errorLabelView: UILabel!
    
    var tableData : Array<Dictionary<String, String>> = []
    
    
    /** --------------------------  TableView Implementation   -------------------------- **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableCell
        cell.titleLabel.text = self.tableData[indexPath.row]["title"]
        cell.authorLabel.text = self.tableData[indexPath.row]["author"]
        cell.dateLabel.text = self.tableData[indexPath.row]["date"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.tableData[indexPath.row]["link"]!
        guard let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url,  options: [:], completionHandler: nil)
    }

    
    /** --------------------------       Utility Function      -------------------------- **/
    func onNewsDataLoaded(data: SwiftyJSON.JSON) -> Void {
        if data["Error Message"].exists() {
            self.onError()
            return
        }
        self.tableData.removeAll()
        for obj in data.array! {
            let entry : [String: String] = ["title": obj["title"].string!, "date":
                "Date: \(obj["pubDate"].string!)", "author": "Author: \(obj["author"].string!)", "link": obj["link"].string!]
            self.tableData.append(entry)
        }
        self.newsTableView.reloadData()
    }
    
    func initView() -> Void {
        self.errorLabelView.isHidden = true
        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
    }
    
    func onError() {
        self.errorLabelView.isHidden = false
        self.newsTableView.isHidden = true
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
