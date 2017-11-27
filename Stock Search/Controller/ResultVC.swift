//
//  ResultViewController.swift
//  Stock Search
//
//  Created by David on 11/21/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class ResultVC: UIViewController {

    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var historicalView: UIView!
    @IBOutlet weak var newsView: UIView!
    
    var symbol: String?
    
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            currentView.isHidden = false
            historicalView.isHidden = true
            newsView.isHidden = true
        case 1:
            currentView.isHidden = true
            historicalView.isHidden = false
            newsView.isHidden = true
        case 2:
            currentView.isHidden = true
            historicalView.isHidden = true
            newsView.isHidden = false
        default:
            break;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrent" {
            let symbol = self.symbol
            (segue.destination as! CurrentVC).symbol = symbol
        } else if segue.identifier == "toHistorical" {
            let symbol = self.symbol
            (segue.destination as! HistoricalVC).symbol = symbol
        } else if segue.identifier == "toNews" {
            let symbol = self.symbol
            (segue.destination as! NewsVC).symbol = symbol
        }
    }
    

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle?.title = symbol
        // Do any additional setup after loading the view.
        SwiftSpinner.show("Loading...")
    }


}
