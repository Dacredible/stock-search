//
//  stockData.swift
//  Stock Search
//
//  Created by David on 11/22/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import Foundation
import SwiftyJSON

class StockData {
    
    var priceTable: [String: Any] = [:]
    var priceChart = JSON()
    var histChart = JSON()
    var SMA = JSON()
    var EMA = JSON()
    var STOCH = JSON()
    var RSI = JSON()
    var ADX = JSON()
    var CCI = JSON()
    var BBANDS = JSON()
    var MACD = JSON()
    var news: [[String: Any]] = []
    
    func setPriceTable(_ priceTableDic: [String: Any]) {
        self.priceTable = priceTableDic
    }
    
    func setPriceChart(_ priceChartDic: JSON) {
        self.priceChart = priceChartDic
    }
    
    func setHistChart(_ histChartDic: JSON) {
        self.histChart = histChartDic
    }
    
    func setSMA(_ SMADic: JSON) {
        self.SMA = SMADic
    }
    
    func setEMA(_ EMADic: JSON) {
        self.EMA = EMADic
    }
    
    func setSTOCH(_ STOCHDic: JSON) {
        self.STOCH = STOCHDic
    }
    
    func setRSI(_ RSIDic: JSON) {
        self.RSI = RSIDic
    }
    
    func setADX(_ ADXDic: JSON) {
        self.ADX = ADXDic
    }
    
    func setCCI(_ CCIDic: JSON) {
        self.CCI = CCIDic
    }
    
    func setBBANDS(_ BBANDSDic: JSON) {
        self.BBANDS = BBANDSDic
    }
    
    func setMACD(_ MACDDic: JSON) {
        self.MACD = MACDDic
    }
    
    func setNews(_ newsDicArr: [[String: Any]]) {
        self.news = newsDicArr
    }
    
}
