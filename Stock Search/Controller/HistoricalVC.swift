//
//  historicalViewController.swift
//  Stock Search
//
//  Created by David on 11/22/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class HistoricalVC: UIViewController {

    @IBOutlet weak var chartView: WKWebView!
    var stockData = StockAPI.shared.getStock()
    var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let htmlPath = Bundle.main.path(forResource: "HighStock", ofType: "html")
        let url = URL(fileURLWithPath: htmlPath!)
        let urlRequest: URLRequest = URLRequest(url: url)
        self.chartView.load(urlRequest)
        
        let webService = WebService()
        webService.getHistChart(symbol: symbol!) { (stockData) in
            self.stockData.histChart = (stockData?.histChart)!
            self.updateChart()
        }
    }

    func updateChart() {
        if let json = stockData.histChart["options"] as? JSON {
            if let options = json.rawString(options: []) {
                self.chartView.evaluateJavaScript("drawChart(\(options))") { (result, error) in
                    guard error == nil else {
                        print("error")
                        return
                    }
                    print("Historical Chart Success")
                }
            }
        }
    }
}
