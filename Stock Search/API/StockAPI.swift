//
//  StockList.swift
//  Stock Search
//
//  Created by David on 11/23/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import Foundation

final class StockAPI {
    //singleton
    static let shared = StockAPI()
    private var stock: StockData
    private init() {
        stock = StockData()
    }
    
//    private var manager = Manager()
    
    func getStock() -> StockData {
        return self.stock
    }
    
}
