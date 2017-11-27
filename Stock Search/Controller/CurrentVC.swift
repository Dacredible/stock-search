//
//  currentViewController.swift
//  Stock Search
//
//  Created by David on 11/22/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit
import SwiftSpinner
import WebKit
import SwiftyJSON

class priceTableCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}


class CurrentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var indicatorPicker: UIPickerView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var chartWebView: WKWebView!
    
    var stockData = StockAPI.shared.getStock()
    var symbol: String?
    let pickerOptions = ["Price", "SMA", "EMA", "STOCH", "RSI", "ADX", "CCI", "BBANS", "MACD"]
    var didSelectRow = 0
    
    //Activity Indicator
    var actIndicatior: UIActivityIndicatorView = UIActivityIndicatorView()
    let whiteView: UIView = UIView()
    let webService = WebService()
    let IO = UserDefaults.standard
    var runningFavList: [String] = []
    //lazy load
    lazy var tableHead: [String] = {
        var heads: [String] = ["Stock Symbol", "Last Price", "Change", "TimeStamp", "Open", "Close", "Day's Range", "Volume"]
        return heads
    }()
    let tableDetailKey: [String] = {
        var keys: [String] = ["Stock Ticker Symbol", "Last Price", "Change", "Timestamp", "Open", "Close", "Day's Range", "Volume"]
        return keys
    }()
    
    //Mark: - tableView protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHead.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currentTableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! priceTableCell
        cell.title.text = tableHead[indexPath.row]
        cell.detail.text = self.stockData.priceTable[tableDetailKey[indexPath.row]] as? String
        if indexPath.row == 2 {
            let charset = CharacterSet(charactersIn: "-")
            guard cell.detail.text != nil else{
                return cell
            }
            if ((cell.detail.text?.rangeOfCharacter(from: charset)) != nil) {
                cell.detail.textColor = UIColor.red
                cell.imgView.image = #imageLiteral(resourceName: "arrow-down")
            } else {
                cell.detail.textColor = UIColor.green
                cell.imgView.image = #imageLiteral(resourceName: "arrow-up")
            }
        }
        return cell
    }
    
    //MARK: - pickerView protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow = row
    }
    
    @IBAction func didSelectChangeBtn(_ sender: Any) {
        self.showActIndicator()

        switch didSelectRow {
        case 0:
            webService.getPriceChart(symbol: symbol!) { (stockData) in
                self.stockData.priceChart = (stockData?.priceChart)!
                if let json = stockData?.priceChart["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 1:
            webService.getSMA(symbol: symbol!) { (stockData) in
                self.stockData.SMA = (stockData?.SMA)!
                if let json = stockData?.SMA["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 2:
            webService.getEMA(symbol: symbol!) { (stockData) in
                self.stockData.EMA = (stockData?.EMA)!
                if let json = stockData?.EMA["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 3:
            webService.getSTOCH(symbol: symbol!) { (stockData) in
                self.stockData.STOCH = (stockData?.STOCH)!
                if let json = stockData?.STOCH["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 4:
            webService.getRSI(symbol: symbol!) { (stockData) in
                self.stockData.RSI = (stockData?.RSI)!
                if let json = stockData?.RSI["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 5:
            webService.getADX(symbol: symbol!) { (stockData) in
                self.stockData.ADX = (stockData?.ADX)!
                if let json = stockData?.ADX["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 6:
            webService.getCCI(symbol: symbol!) { (stockData) in
                self.stockData.CCI = (stockData?.CCI)!
                if let json = stockData?.CCI["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 7:
            webService.getBBANDS(symbol: symbol!) { (stockData) in
                self.stockData.BBANDS = (stockData?.BBANDS)!
                if let json = stockData?.BBANDS["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        case 8:
            webService.getMACD(symbol: symbol!) { (stockData) in
                self.stockData.MACD = (stockData?.MACD)!
                if let json = stockData?.MACD["options"] as? JSON {
                    self.updateChart(json)
                }
                self.hideActIndicator()
            }
        default:
            return
        }
        
    }
    
    @IBAction func didSelectStarBtn(_ sender: Any) {
        
        if starBtn.isSelected {
            let index = runningFavList.index(of: symbol!)
            runningFavList.remove(at: index!)
            IO.set(runningFavList, forKey: "symbolList")
        } else {
            runningFavList.append(symbol!)
            IO.set(runningFavList, forKey: "symbolList")
        }
        starBtn.isSelected = !starBtn.isSelected
    }
    
    //MARK: -
    func updateChart(_ json: JSON) {
            if let options = json.rawString(options: []) {
                self.chartWebView.evaluateJavaScript("drawChart(\(options))") { (result, error) in
                    guard error == nil else {
                        print("error")
                        return
                    }
                    print("Chart Success")
                }
            }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.currentTableView.delegate = self
        self.currentTableView.dataSource = self
        self.indicatorPicker.delegate = self
        self.indicatorPicker.dataSource = self
    
        //get local storage
        runningFavList = IO.object(forKey: "symbolList") as! [String]
        //set btn Img
        starBtn.setBackgroundImage(#imageLiteral(resourceName: "star-filled"), for: .selected)
        starBtn.setBackgroundImage(#imageLiteral(resourceName: "star-empty"), for: .normal)
        //init webView
        let htmlPath = Bundle.main.path(forResource: "HighChart", ofType: "html")
        let url = URL(fileURLWithPath: htmlPath!)
        let urlRequest: URLRequest = URLRequest(url: url)
        self.chartWebView.load(urlRequest)
        
        webService.getPriceTable(symbol: symbol!) { (stockData) in
            self.stockData.priceTable = (stockData?.priceTable)!
            print("Price Table Success")
            self.currentTableView.reloadData()
            SwiftSpinner.hide()
        }
        webService.getPriceChart(symbol: symbol!) { (stockData) in
            self.stockData.priceChart = (stockData?.priceChart)!
            if let json = stockData?.priceChart["options"] as? JSON {
                self.updateChart(json)
                print("initiating first price Chart")
            }
            self.hideActIndicator()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if runningFavList.contains(symbol!) {
            starBtn.isSelected = true
        } else {
            starBtn.isSelected = false
        }
        
        whiteView.frame = CGRect(x: 0, y: 0, width: 375, height: 408)
        whiteView.backgroundColor = UIColor.white
        chartWebView.addSubview(whiteView)
        
        actIndicatior.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 50)
        actIndicatior.hidesWhenStopped = true
        actIndicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        actIndicatior.color = UIColor.green
        whiteView.addSubview(actIndicatior)
        self.showActIndicator()


        
    }
    
    //MARK: -
    func showActIndicator() {
        whiteView.isHidden = false
        actIndicatior.startAnimating()
    }

    func hideActIndicator() {
        whiteView.isHidden = true
        actIndicatior.stopAnimating()
    }
}
