//
//  CurrentViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/24/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class CurrentViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var FBButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var indicatorPicker: UIPickerView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var indicatorWebView: UIWebView!
    @IBOutlet weak var subContentView: UIView!
    
    
    // var quoteData: Any = nil;
    let indicatorPickerData = ["Price", "SMA", "EMA", "STOCH", "RSI", "ADX", "CCI", "BBANDS", "MACD"]
    let tableHeaders = ["Stock Symbol", "Last Price", "Change", "Timestamp", "Open", "Close", "Day's Range", "Volume"]
    var tableInfos = ["", "", "", "", "", "", "", ""]
    var ticker = ""
    var indicator = "Price"
    
    /** --------------------------  TableView Implementation   -------------------------- **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quoteTableView.dequeueReusableCell(withIdentifier: "QuoteTableViewCell", for: indexPath) as! QuoteTableCell
        cell.headerLabel?.text = tableHeaders[indexPath.row]
        cell.contentLabel?.text = tableInfos[indexPath.row]
        if indexPath.row == 2, tableInfos[2].count > 0 {
            let headingChar = Array(tableInfos[2])[0]
            cell.infoImageView.image = (headingChar == "-" ? #imageLiteral(resourceName: "DownArrowIcon") : #imageLiteral(resourceName: "UpArrowIcon"))
        }
        return cell
    }
    
    /** --------------------------   WebView Implementation    -------------------------- **/
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        var newBounds = self.indicatorWebView.bounds
        print("Before resizing: \(newBounds.size.height)")
        // newBounds.size.height = self.indicatorWebView.scrollView.contentSize.height
        self.indicatorWebView.bounds = newBounds
        print("Finish resizing: \(newBounds.size.height)")
    }
    
    /** --------------------------       Indicator Picker      -------------------------- **/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.indicatorPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
        }
        
        pickerLabel?.font =  UIFont.systemFont(ofSize: 16.0)
        pickerLabel?.textAlignment = NSTextAlignment.center
        pickerLabel?.text = indicatorPickerData[row]
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.indicatorPickerData[row]
    }
    
    /** --------------------------       Action Bindings       -------------------------- **/
    
    
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func initView() -> Void {
        
    }
    
    func loadWebView(indicator: String) {
        guard let path = Bundle.main.path(forResource: "webview/indicators", ofType: "html") else {
            print("indicators.html loading failed")
            return
        }
        let html = try! String(contentsOfFile: path)
        self.indicatorWebView.loadHTMLString(html, baseURL: nil)
        self.loadWebViewChart(indicator: indicator)
        self.indicator = indicator
    }
    
    func loadWebViewChart(indicator: String) {
        self.indicatorWebView.stringByEvaluatingJavaScript(from: "loader(\(self.ticker, indicator)")
    }
    
    func resizeScrollView(height: CGFloat) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
    func onTableDataLoaded(data: SwiftyJSON.JSON) -> Void {
        tableInfos[0] = data["quote"]["ticker"].string!
        tableInfos[1] = "\(data["quote"]["price"].double!)"
        let change = "\(data["quote"]["change"].double!)"
        let changePercent = "\(data["quote"]["changePercent"].double!)"
        tableInfos[2] = "\(change) (\(changePercent)%)"
        tableInfos[3] = data["quote"]["timestamp"].string!
        tableInfos[4] = data["quote"]["open"].string!
        tableInfos[5] = data["quote"]["close"].string!
        tableInfos[6] = data["quote"]["range"].string!
        let volume = Int(data["quote"]["volume"].double! * 1000000) as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        tableInfos[7] = numberFormatter.string(from: volume)!
        quoteTableView.reloadData()
    }
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.resizeScrollView(height: 750.0)
        
        self.indicatorWebView.isOpaque = false
        self.indicatorWebView.backgroundColor = UIColor.clear
        print("when initializing: \(self.indicatorWebView.bounds.size.height)")
        self.indicatorWebView.delegate = self
        self.loadWebView(indicator: "Price")
        
        self.quoteTableView.delegate = self
        self.quoteTableView.dataSource = self
        self.quoteTableView.alwaysBounceVertical = false
        
        self.indicatorPicker.delegate = self
        self.indicatorPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
