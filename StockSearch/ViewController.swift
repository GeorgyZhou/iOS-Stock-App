//
//  ViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/22/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import EasyToast
import AlamofireSwiftyJSON
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ClearButton: UIButton!
    @IBOutlet weak var AutoRefreshButton: UISwitch!
    @IBOutlet weak var FavoriteList: UITableView!
    @IBOutlet weak var OrderPicker: UIPickerView!
    @IBOutlet weak var SortPicker: UIPickerView!
    @IBOutlet weak var waitSpinner: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: SearchTextField!
    
    
    let sortIndicators = ["Default", "Symbol", "Price", "Change", "Change(%)"]
    let orderIndicators = ["Ascending", "Descending"]
    var sortindicator : String = "default"
    var isAscending: Bool = true
    var favStockList : [[String: Any]] = []
    var ticker : String = ""
    var refreshTimer : Timer?
    var refreshCount = 0
    
    
    /** -------------------------- PickerView Initialize -------------------------- **/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return fetchTextForRow(pickerView: pickerView, rowIndex: row)
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == SortPicker {
            return sortIndicators.count
        } else {
            return orderIndicators.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
        }
    
        pickerLabel?.font =  UIFont.systemFont(ofSize: 16.0)
        pickerLabel?.textAlignment = NSTextAlignment.center
        pickerLabel?.text = fetchTextForRow(pickerView: pickerView, rowIndex: row)
        
        return pickerLabel!
    }
    
    func fetchTextForRow(pickerView: UIPickerView, rowIndex: Int) -> String? {
        if pickerView == SortPicker {
            return sortIndicators[rowIndex]
        } else {
            return orderIndicators[rowIndex]
        }
    }
    
    func resortFavoriteList(by: String, isAscending: Bool) {
        self.favStockList = self.favStockList.sorted { item1, item2 in
            if by != "ticker" {
                let indicator1 = item1[by] as! Double
                let indicator2 = item2[by] as! Double
                return isAscending ? indicator1 < indicator2 : indicator1 > indicator2
            } else {
                let indicator1 = item1[by] as! String
                let indicator2 = item2[by] as! String
                return isAscending ? indicator1 < indicator2 : indicator1 > indicator2
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.SortPicker {
            switch self.sortIndicators[row] {
            case "Default":
                self.sortindicator = "default"
                self.loadUserDefaults()
            case "Price":
                self.sortindicator = "price"
                self.resortFavoriteList(by: "price", isAscending: self.isAscending)
            case "Symbol":
                self.sortindicator = "ticker"
                self.resortFavoriteList(by: "ticker", isAscending: self.isAscending)
            case "Change":
                self.sortindicator = "change"
                self.resortFavoriteList(by: "change", isAscending: self.isAscending)
            case "Cahnge(%)":
                self.sortindicator = "changePercent"
                self.resortFavoriteList(by: "changePercent", isAscending: self.isAscending)
            default:
                break
            }
        } else {
            self.isAscending = (self.orderIndicators[row] == "Ascending")
            if self.sortindicator == "default" {
                self.loadUserDefaults(self.isAscending)
            } else {
                self.resortFavoriteList(by: self.sortindicator, isAscending: self.isAscending)
            }
        }
        self.FavoriteList.reloadData()
    }
    
    /** --------------------------  TableView Implementation   -------------------------- **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favStockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.FavoriteList.dequeueReusableCell(withIdentifier: "FavTableViewCell", for: indexPath) as! FavTableCell
        let row = indexPath.row
        cell.tickerLabel.text = favStockList[row]["ticker"] as? String
        cell.priceLabel.text = "$\(favStockList[row]["price"]!)"
        cell.changeLabel.text = "\(favStockList[row]["change"]!) (\(favStockList[row]["changePercent"]!)%)"
        let change = favStockList[row]["change"] as! Double
        if change >= 0 {
            cell.changeLabel.textColor = UIColor.green
        } else {
            cell.changeLabel.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticker = self.favStockList[indexPath.row]["ticker"] as! String
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.ticker = ticker
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let ticker = self.favStockList[indexPath.row]["ticker"] as! String
            self.favStockList.remove(at: indexPath.row)
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "stock-\(ticker)")
            defaults.synchronize()
            self.FavoriteList.reloadData()
            return
        }
    }

    /** --------------------------       Actions Binding       -------------------------- **/
    
    @IBAction func onSearchButtonClick(_ sender: Any) {
        
        if validate() {
            let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailViewController.ticker = self.ticker
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            self.view.showToast("Please enter a stock name or symbol", position: ToastPosition.bottom, popTime: 5, dismissOnTap: false)
        }
    }
    
    
    @IBAction func onClearButtonClick(_ sender: Any) {
        self.ticker = ""
        self.searchTextField.text = ""
        self.searchTextField.filterStrings([])
    }
    
    
    @IBAction func onRefreshButtonClick(_ sender: Any) {
        // TODO(reload data and update table list)
        self.refreshFavList()
    }
    
    @IBAction func onAutoRefreshToggle(_ sender: Any) {
        if self.AutoRefreshButton.isOn {
            self.refreshTimer?.invalidate()
            self.refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.refreshFavList), userInfo: nil, repeats: true)
        } else {
            self.refreshTimer?.invalidate()
        }
    }
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func validate() -> Bool {
        let inputTicker = searchTextField.text
        let validTicker = inputTicker?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if validTicker == nil || validTicker?.count == 0 {
            return false
        }
        ticker = validTicker!
        return true
    }
    
    @objc func refreshFavList() {
        let totalCount = self.favStockList.count
        if totalCount == 0 { return }
        self.waitSpinner.startAnimating()
        self.refreshCount = 0
        for index in 0...(totalCount - 1) {
            let ticker = self.favStockList[index]["ticker"] as! String
            self.getQuote(ticker: ticker, index: index, totalCount: totalCount)
        }
    }
    
    func getQuote(ticker: String, index: Int, totalCount: Int) {
        let url = "http://ec2-18-221-164-179.us-east-2.compute.amazonaws.com/api/quote?symbol=\(ticker)"
        Alamofire.request(url, method: .get).responseSwiftyJSON { response in
            if response.result.isSuccess, let json = response.result.value {
                self.favStockList[index] = ["ticker": ticker, "price": json["quote"]["price"].double!, "change": json["quote"]["change"].double!, "changePercent": json["quote"]["changePercent"].double!]
            } else {
                print(response.error!)
            }
            self.refreshCount += 1
            if self.refreshCount == totalCount {
                self.FavoriteList.reloadData()
                self.waitSpinner.stopAnimating()
            }
        }
    }
    
    func loadSuggestions() -> Void {
        let acUrl = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=" + ticker;
        Alamofire.request(acUrl, method: .get).responseSwiftyJSON { response in
            if response.result.isSuccess, let json = response.result.value {
                let data = self.parseJSON(json: json)
                self.searchTextField.filterStrings(data)
                self.searchTextField.stopLoadingIndicator()
            } else {
                print(response.error!)
                self.searchTextField.stopLoadingIndicator()
            }
        }
    }
    
    
    func parseJSON(json: SwiftyJSON.JSON) -> [String] {
        var sugArray : Array<String> = []
        for dic in json.array! {
            let symbol = dic["Symbol"].string
            let Name = dic["Name"].string
            let Exchange = dic["Exchange"].string
            let sug = "\(symbol!) - \(Name!) (\(Exchange!))"
            sugArray.append(sug)
        }
        return sugArray
    }
    
    func loadUserDefaults(_ isAscending : Bool = true) {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        var stockOrder : [String] = []
        self.favStockList = []
        if dictionary.keys.contains("stockOrder") {
            stockOrder = dictionary["stockOrder"] as! [String]
        }
        if !isAscending {
            stockOrder = Array(stockOrder.reversed())
        }
        for ticker in stockOrder {
            self.favStockList.append(dictionary["stock-\(ticker)"] as! [String: Any])
        }
    }
    
    func initView() -> Void {
        // Initialize favorite stock lists
        self.FavoriteList.allowsMultipleSelectionDuringEditing = false
        self.FavoriteList.delegate = self
        self.FavoriteList.dataSource = self
        
        // Initialize indicator color
        self.waitSpinner.color = UIColor.green
        
        // Initialize auto refresh
        self.AutoRefreshButton.isOn = false
        
        // Initialize favorite list table data and delegate
        self.FavoriteList.delegate = self
        self.FavoriteList.dataSource = self
        
        // Initialize PickerView data and delegate
        self.SortPicker.dataSource = self
        self.SortPicker.delegate = self
        self.OrderPicker.dataSource = self
        self.OrderPicker.delegate = self
        
        // Initialize auto complete text view
        self.searchTextField.maxNumberOfResults = 5
        self.searchTextField.startVisible = true
        self.searchTextField.userStoppedTypingHandler = {
            if let criteria = self.searchTextField.text {
                if criteria.count > 1, self.validate() {
                    self.searchTextField.showLoadingIndicator()
                    self.loadSuggestions()
                }
            }
        } as (() -> Void)
        self.searchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.searchTextField.text = item.title.components(separatedBy: " ")[0]
        }
        self.view.addSubview(self.searchTextField)
    }
    
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide navigation bar
        self.loadUserDefaults()
        self.FavoriteList.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

