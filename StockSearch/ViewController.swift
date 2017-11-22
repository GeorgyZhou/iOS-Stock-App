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
    @IBOutlet weak var SortSelector: UIPickerView!
    @IBOutlet weak var OrderSelector: UIPickerView!
    @IBOutlet weak var FavoriteList: UITableView!
    
    let sortIndicators = ["Default", "Symbol", "Price", "Change", "Change(%)"];
    let orderIndicators = ["Ascending", "Descending"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.SortSelector.dataSource = self;
        self.SortSelector.delegate = self;
        self.OrderSelector.dataSource = self;
        self.OrderSelector.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSoruce.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }

}

