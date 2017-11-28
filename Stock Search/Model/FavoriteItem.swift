//
//  FavoriteList.swift
//  Stock Search
//
//  Created by David on 11/25/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import Foundation

struct FavoriteItem {
    var symbol: String?
    var price: String?
    var change: String?
    var change_percent: String?
    
    init() {
        symbol = ""
        price = ""
        change = ""
        change_percent = ""
    }
}
