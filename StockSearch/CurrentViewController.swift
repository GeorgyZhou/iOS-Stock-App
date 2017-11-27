//
//  CurrentViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/24/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import SwiftyJSON
import EasyToast

class CurrentViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var FBButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var indicatorPicker: UIPickerView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var indicatorWebView: UIWebView!
    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var webViewHeightCst: NSLayoutConstraint!
    @IBOutlet weak var waitSpinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabelView: UILabel!
    
    
    // var quoteData: Any = nil;
    let indicatorPickerData = ["Price", "SMA", "EMA", "STOCH", "RSI", "ADX", "CCI", "BBANDS", "MACD"]
    let tableHeaders = ["Stock Symbol", "Last Price", "Change", "Timestamp", "Open", "Close", "Day's Range", "Volume"]
    var tableInfos = ["", "", "", "", "", "", "", ""]
    var ticker = ""
    var indicator = "Price"
    var checkTimer : Timer?
    var defaults: Any?
    
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
        self.loadWebViewChart(indicator: self.indicator)
        self.resizeWebViewHeight()
        self.resizeScrollViewByWebViewHeight()
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indicator = indicatorPickerData[row]
    }
    
    /** --------------------------       Action Bindings       -------------------------- **/
    
    @IBAction func onIndicatorChange(_ sender: Any) {
        self.errorLabelView.isHidden = true
        self.indicatorWebView.isHidden = false
        self.loadWebViewChart(indicator: self.indicator)
    }
    
    @IBAction func onStarStock(_ sender: Any) {
        if self.isStar {
            self.starButton.setImage(#imageLiteral(resourceName: "GrayStarIcon"), for: .normal)
        } else {
            self.starButton.setImage(#imageLiteral(resourceName: "YelloStarIcon"), for: .normal)
        }
    }
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func initView() -> Void {
        self.errorLabelView.isHidden = true
        self.defaults = UserDefaults.dictionaryRepresentation()
    }
    
    func startTimer() -> Void {
        self.checkTimer?.invalidate()
        self.checkTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(CurrentViewController.checkChartStatus), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void {
        self.checkTimer?.invalidate()
    }
    
    func onError() {
        self.errorLabelView.isHidden = false
        self.indicatorWebView.isHidden = true
    }
    
    func resizeWebViewHeight() {
        self.webViewHeightCst.constant = self.indicatorWebView.scrollView.contentSize.height
        var newBounds = self.indicatorWebView.bounds
        newBounds.size.height = self.indicatorWebView.scrollView.contentSize.height
        self.indicatorWebView.bounds = newBounds
    }
    
    @objc func checkChartStatus() {
        let checkFunc = "checkChartStatus();"
        let status = self.indicatorWebView.stringByEvaluatingJavaScript(from: checkFunc)
        if status == nil || status == "No" {
        } else {
            self.waitSpinner.stopAnimating()
            self.stopTimer()
            if checkError() {
                self.onError()
            } else {
                self.resizeWebViewHeight()
                self.resizeScrollViewByWebViewHeight()
            }
        }
    }
    
    func checkError() -> Bool {
        let checkFunc = "checkError();"
        let status = self.indicatorWebView.stringByEvaluatingJavaScript(from: checkFunc)
        if status == nil || status == "Yes" {
            return true
        } else {
            return false
        }
    }
    
    func loadWebView(indicator: String) {
        guard let url = Bundle.main.url(forResource: "webview/indicators", withExtension: "html") else {
            print("indicators.html loading failed")
            return
        }
        let request = URLRequest(url: url)
        self.indicatorWebView.loadRequest(request)
        self.indicator = indicator
    }
    
    func loadWebViewChart(indicator: String) {
        self.waitSpinner.startAnimating()
        self.startTimer()
        let callFunc = "loader('\(self.ticker)', '\(indicator)');"
        self.indicatorWebView.stringByEvaluatingJavaScript(from: callFunc)
    }
    
    func resizeScrollViewByWebViewHeight() {
        let scrollHeight = self.indicatorWebView.frame.height + self.indicatorWebView.frame.origin.y
        self.resizeScrollView(height: scrollHeight)
    }
    
    func resizeScrollView(height: CGFloat) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
    func onTableDataLoaded(data: SwiftyJSON.JSON) -> Void {
        if data["Error Message"].exists() {
            self.view.showToast("Failed to load data. Please try again later", position: .bottom, popTime: 5, dismissOnTap: false)
            return;
        }
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
        
        self.resizeScrollView(height: 900.0)
        
        self.indicatorWebView.isOpaque = false
        self.indicatorWebView.backgroundColor = UIColor.clear
        self.indicatorWebView.scrollView.isScrollEnabled = false
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
