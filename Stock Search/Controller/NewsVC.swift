//
//  newsViewController.swift
//  Stock Search
//
//  Created by David on 11/22/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit

class NewsTableCell: UITableViewCell {
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!
    var stockData = StockAPI.shared.getStock()
    var symbol: String?
    
    //MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsData = stockData.news as? [[String: Any]] else{
            return 0
        }
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableCell
        if let newsData = stockData.news as? [[String: Any]] {
            cell.mainTitle?.text = newsData[indexPath.row]["title"] as? String
            cell.authorLabel?.text = "Author: \(newsData[indexPath.row]["author"] as! String)"
            cell.dateLabel?.text = "Date: \(newsData[indexPath.row]["pubDate"] as! String)" 
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsData = stockData.news as? [[String: Any]] {
            let link = newsData[indexPath.row]["link"] as! String
            if let url = URL(string: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // clean highlighted selected row
            newsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
//        self.newsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.newsTableView.rowHeight = UITableViewAutomaticDimension
        self.newsTableView.estimatedRowHeight = 100
        
        let webService = WebService()
        webService.getNews(symbol: symbol!) { (stockData) in
            self.stockData.news = (stockData?.news)!
            self.newsTableView.reloadData()
        }
        
    }

}
