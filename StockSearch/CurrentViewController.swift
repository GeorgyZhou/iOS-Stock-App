//
//  CurrentViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/24/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import Highcharts

class CurrentViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var scrollView: UIView!
    @IBOutlet weak var FBButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var indicatorPicker: UIPickerView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var quoteTableView: UITableView!
    
    
    var quoteData: Any = nil;
    let indicatorPickerData = ["Price", "SMA", "EMA", "STOCH", "RSI", "ADX", "CCI", "BBANDS", "MACD"]
    let tableHeaders = ["Stock Symbol", "Last Price", "Change", "Timestamp", "Open", "Close", "Day's Range", "Volume"]
    var tableInfos = ["", "", "", "", "", "", "", ""]
    
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
        return cell
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
    
    /** --------------------------       Utility Function      -------------------------- **/
    
    func initView() -> Void {
        self.quoteTableView.delegate = self
        self.quoteTableView.dataSource = self
        
        self.indicatorPicker.delegate = self
        self.indicatorPicker.dataSource = self
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
