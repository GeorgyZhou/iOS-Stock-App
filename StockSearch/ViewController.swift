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
    var searchTextField : SearchTextField = SearchTextField(frame: CGRect(x: 22, y: 146, width: 328, height: 30));
    
    
    /** -------------------------- PickerView Initialize -------------------------- **/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        // TODO (resort data)
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
            detailViewController.ticker = TickerInput.text!.trimmingCharacters(
                in: NSCharacterSet.whitespacesAndNewlines)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            
        }
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
        loadSuggestions()
    }
    
    @IBAction func onInputEnd(_ sender: Any) {
        searchTextField.isHidden = true
    }
    
    /** --------------------------       Utility Function      -------------------------- **/
    func validate() -> Bool {
        let inputTicker = TickerInput.text
        let validTicker = inputTicker?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if validTicker == nil || validTicker?.characters.count == 0 {
            return false
        }
        return true
    }
    
    func loadSuggestions() -> Void {
        
    }
    
    
    /** --------------------------       View Initialize       -------------------------- **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize PickerView data and delegate
        self.SortPicker.dataSource = self
        self.SortPicker.delegate = self
        self.OrderPicker.dataSource = self
        self.OrderPicker.delegate = self
        
        // Initialize auto complete text view
        searchTextField = SearchTextField(frame: CGRect(x: 22, y: 145, width: 328, height: 160))
        searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        searchTextField.isHidden = true
        self.view.addSubview(searchTextField)
        
        
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

