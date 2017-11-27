//
//  FavListAPI.swift
//  Stock Search
//
//  Created by David on 11/25/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import Foundation

final class FavListAPI {
   //singleton
    static let shared = FavListAPI()

    private var favList = [FavoriteItem]()
    
    private init(){
        
    }
    
    func getFavList() -> [FavoriteItem] {
        return favList
    }
    
    func addItem(_ item: FavoriteItem) {
        favList.append(item)
    }
    
    func removeItem(at index: Int) {
        favList.remove(at: index)
    }
}
