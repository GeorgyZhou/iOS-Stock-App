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

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ClearButton: UIButton!
    @IBOutlet weak var AutoRefreshButton: UISwitch!
    @IBOutlet weak var FavoriteList: UITableView!
    @IBOutlet weak var OrderPicker: UIPickerView!
    @IBOutlet weak var SortPicker: UIPickerView!
    
    var searchTextField : SearchTextField = SearchTextField(frame: CGRect(x: 22, y: 111, width: 328, height: 30))
    
    let sortIndicators = ["Default", "Symbol", "Price", "Change", "Change(%)"]
    let orderIndicators = ["Ascending", "Descending"]
    var ticker : String = ""
    
    
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
        // TODO (resort data)
        
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
    }
    
    @IBAction func onAutoRefreshToggle(_ sender: Any) {
        // TODO(change auto refresh policy)
    }
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func validate() -> Bool {
        let inputTicker = searchTextField.text
        let validTicker = inputTicker?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if validTicker == nil || validTicker?.characters.count == 0 {
            return false
        }
        ticker = validTicker!
        return true
    }
    
    func loadSuggestions() -> Void {
        let acUrl = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=" + ticker;
        Alamofire.request(acUrl).responseJSON { response in
            switch response.result {
            case.success(let json):
                let data = self.parseJSON(json: json)
                self.searchTextField.filterStrings(data)
                self.searchTextField.stopLoadingIndicator()
            case.failure(let error):
                print(error)
                self.searchTextField.stopLoadingIndicator()
            }
        }
    }
    
    func parseJSON(json: Any) -> [String] {
        let sugs = json as! Array<Any>
        var sugArray : Array<String> = []
        for obj in sugs {
            let dic = obj as! Dictionary<String, String>
            let symbol = dic["Symbol"]! as String
            let Name = dic["Name"]! as String
            let Exchange = dic["Exchange"]! as String
            let sug = symbol + " - " + Name + " (" + Exchange + ")"
            sugArray.append(sug)
        }
        return sugArray
    }
    
    func initView() -> Void {
        // Initialize PickerView data and delegate
        self.SortPicker.dataSource = self
        self.SortPicker.delegate = self
        self.OrderPicker.dataSource = self
        self.OrderPicker.delegate = self
        
        // Initialize auto complete text view
        self.searchTextField.backgroundColor = UIColor.white
        self.searchTextField.placeholder = "Enter Stock Ticker Symbol"
        self.searchTextField.textAlignment = .center
        self.searchTextField.maxNumberOfResults = 5
        self.searchTextField.userStoppedTypingHandler = {
            if let criteria = self.searchTextField.text {
                if criteria.characters.count > 1 && self.validate() {
                    self.searchTextField.showLoadingIndicator()
                    self.loadSuggestions()
                }
            }
        }
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

