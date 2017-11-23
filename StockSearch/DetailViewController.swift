//
//  DetailViewController.swift
//  StockSearch
//
//  Created by Michael Zhou on 11/22/17.
//  Copyright © 2017 michaelzhou. All rights reserved.
//

import UIKit
import Highcharts

class DetailViewController: UIViewController{
    
    
    
    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var indicatorPicker: UIPickerView!
    @IBOutlet weak var changeIndicatorButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var ticker: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Load table
        // self.currentTableView.delegate = self
        // self.currentTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
