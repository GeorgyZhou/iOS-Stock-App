//
//  ViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/22/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ClearButton: UIButton!
    @IBOutlet weak var TickerInput: UITextField!
    @IBOutlet weak var AutoRefreshButton: UISwitch!
    @IBOutlet weak var FavoriteList: UITableView!
    @IBOutlet weak var OrderPicker: UIPickerView!
    @IBOutlet weak var SortPicker: UIPickerView!
 
    
    
    let sortIndicators = ["Default", "Symbol", "Price", "Change", "Change(%)"];
    let orderIndicators = ["Ascending", "Descending"];
    
    
    /** -------------------------- PickerView Initialize -------------------------- **/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // TODO (resort data)
        return fetchTextForRow(pickerView: pickerView, rowIndex: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // TODO (resort data)
        
        if pickerView == SortPicker {
            return sortIndicators.count
        } else {
            return orderIndicators.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
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
        // TODO(fetch data and switch view)
    }
    
    
    @IBAction func onClearButtonClick(_ sender: Any) {
        // TODO(clear the input ticker and cache data)
    }
    
    
    @IBAction func onRefreshButtonClick(_ sender: Any) {
        // TODO(reload data and update table list)
    }
    
    @IBAction func onAutoRefreshToggle(_ sender: Any) {
        // TODO(change auto refresh policy)
    }
    
    @IBAction func onInputChange(_ sender: Any) {
        // TODO(check API auto complete)
    }
    
    
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Intialize PickerView data and delegate
        self.SortPicker.dataSource = self
        self.SortPicker.delegate = self
        self.OrderPicker.dataSource = self
        self.OrderPicker.delegate = self
        
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

