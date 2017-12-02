//
//  WebService.swift
//  Stock Search
//
//  Created by David on 11/23/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebService {
    let BASE_URL: String?
    let stockData = StockData()
    
    init() {
        self.BASE_URL = "http://stocksearch.us-east-2.elasticbeanstalk.com/api/ios/"
//        self.BASE_URL = "http://0.0.0.0:3000/api/ios"
    }
    
    func getPriceTable(symbol: String, completion: @escaping (StockData?) -> Void ) {
        let url = "\(self.BASE_URL!)pricetable?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let jsonDic = response.result.value as? [String: Any]{
                guard jsonDic["Error Message"] == nil else{
                    completion(nil)
                    return
                }
                self.stockData.setPriceTable(jsonDic)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getPriceChart(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)pricechart?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setPriceChart(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getHistChart(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)histchart?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setHistChart(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getSMA(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)sma?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setSMA(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getEMA(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)ema?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setEMA(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getRSI(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)rsi?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setRSI(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getSTOCH(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)stoch?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setSTOCH(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getADX(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)adx?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setADX(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getCCI(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)cci?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setCCI(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getBBANDS(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)bbands?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setBBANDS(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getMACD(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)macd?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data: data)
                guard json["Error Message"] == JSON.null else{
                    completion(nil)
                    return
                }
                self.stockData.setMACD(json)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getNews(symbol: String, completion: @escaping (StockData?) -> Void ){
        let url = "\(self.BASE_URL!)news?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let jsonDic = response.result.value as? [[String: Any]]{
                self.stockData.setNews(jsonDic)
                completion(self.stockData)
            } else {
                completion(nil)
            }
        }
    }
    
    func getFavItem(symbol: String, completion: @escaping (FavoriteItem?) -> Void ){
        var favItem = FavoriteItem()
        let url = "\(self.BASE_URL!)pricetable?stockSymbol=\(symbol)"
        Alamofire.request(url).responseJSON { response in
            if let jsonDic = response.result.value as? [String: Any]{
                guard jsonDic["Error Message"] == nil else{
                    completion(nil)
                    return
                }
                favItem.symbol = (jsonDic["Stock Ticker Symbol"] as! String)
                favItem.price = (jsonDic["Last Price"] as! String)
                let changeStr = jsonDic["Change"] as! String
                favItem.change = (changeStr.replacingOccurrences(of: "\\((.*?)\\)", with: "", options: .regularExpression))
                let range = changeStr.range(of: "\\((.*?)\\)", options: .regularExpression)
                favItem.change_percent = String(changeStr[range!])
                completion(favItem)
            } else {
                completion(nil)
            }
        }
        

    }
    
//    static func postFB(optioins: String, completioin: @escaping (String) -> Void) {
//        var parameter: JSON = {"options":{"chart":{"type":"line","zoomType":"x"},"title":{"text":"Simple Moving Average (SMA)"},"subtitle":{"text":"<a href=\" https://www.alphavantage.co/\" target=\"_blank\">Source: Alpha Vantage</a>","useHTML":true,"style":{"color":"blue"}},"yAxis":{"title":{"text":"SMA"}},"xAxis":{"categories":["05/26","05/30","05/31","06/01","06/02","06/05","06/06","06/07","06/08","06/09","06/12","06/13","06/14","06/15","06/16","06/19","06/20","06/21","06/22","06/23","06/26","06/27","06/28","06/29","06/30","07/03","07/05","07/06","07/07","07/10","07/11","07/12","07/13","07/14","07/17","07/18","07/19","07/20","07/21","07/24","07/25","07/26","07/27","07/28","07/31","08/01","08/02","08/03","08/04","08/07","08/08","08/09","08/10","08/11","08/14","08/15","08/16","08/17","08/18","08/21","08/22","08/23","08/24","08/25","08/28","08/29","08/30","08/31","09/01","09/05","09/06","09/07","09/08","09/11","09/12","09/13","09/14","09/15","09/18","09/19","09/20","09/21","09/22","09/25","09/26","09/27","09/28","09/29","10/02","10/03","10/04","10/05","10/06","10/09","10/10","10/11","10/12","10/13","10/16","10/17","10/18","10/19","10/20","10/23","10/24","10/25","10/26","10/27","10/30","10/31","11/01","11/02","11/03","11/06","11/07","11/08","11/09","11/10","11/13","11/14","11/15","11/16","11/17","11/20","11/21","11/22","11/24","11/27","11/28","11/29"],"tickInterval":5},"plotOptions":{"series":{"label":{"connectorAllowed":false}}},"series":[{"color":"#eb4d47","name":"TSLA","data":[312.929,314.851,317.251,320.677,323.356,327.005,331.255,336.834,342.812,346.861,350.248,354.333,358.298,361.795,364.95,367.198,369.137,370.812,372.073,374.686,376.534,375.176,374.234,372.775,371.796,370.078,365.563,358.806,351.867,345.127,340.1,336.815,332.032,328.735,324.531,322.093,321.91,324.019,325.537,328.184,329.422,330.855,331.96,332.689,333.079,332.212,332.275,333.992,336.843,338.108,340.67,342.638,344.732,347.012,351.045,355.321,359.023,359.506,358.561,356.83,354.443,353.367,353.12,352.138,350.324,348.827,347.854,348.252,349.046,350.219,350.537,350.321,349.368,350.932,352.641,354.528,356.974,359.365,362.325,364.876,367.814,369.401,370.17,368.3,366.55,364.024,360.22,356.349,352.002,349.306,347.416,346.301,346.88,346.675,347.709,349.072,350.68,352.127,353.034,353.795,354.259,353.907,352.729,352.137,350.312,347.436,344.485,341.015,337.963,335.541,331.684,326.429,322.528,319.104,315.975,313.83,311.512,309.724,309.256,306.973,305.995,307.319,308.215,308.811,309.987,310.808,312.064,313.446,313.661,313.545]}]}}
//        let url = "http://export.highcharts.com/"
//        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON {}
//    }
    
    static func getAutoComplete(input: String, completion: @escaping ([String]) -> Void) {
        var resultArr = [String]()
        var count = 0
        let url = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=\(input)"
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                if let items = json.array {
                    for item in items {
                        count = count + 1
                        let name = item["Name"].rawString()
                        let exchange = item["Exchange"].rawString()
                        let symbol = item["Symbol"].rawString()
                        let result = "\(symbol!) - \(name!) (\(exchange!))"
                        resultArr.append(result)
                        if count >= 5 {
                            break
                        }
                    }
                }
                completion(resultArr)
            }
        }
    }
    
}
