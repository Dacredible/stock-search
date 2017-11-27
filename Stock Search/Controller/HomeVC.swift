//
//  ViewController.swift
//  Stock Search
//
//  Created by David on 11/20/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var stockTableView: UITableView!
    @IBOutlet weak var autoRefresh: UISwitch!
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var orderPicker: UIPickerView!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var getQuoteBtn: UIButton!
    
    let sortOptions = ["Default", "Symbol", "Price", "Change", "Change(%)"]
    let orderOptions = ["Ascending", "Descending"]
    var favList = FavListAPI.shared.getFavList()
    var symbolList: [String] = []
    var isInputEmpty: Bool = true
    let IO = UserDefaults.standard
    let webService = WebService()
    
    lazy var testData: [Int] = {
        var nums = [Int]()
        for i in 0...20 {
            nums.append(i)
        }
        return nums
    }()
    
    //MARK: - tableView protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavListTableCell

        cell.symbolLabel?.text = favList[indexPath.row].symbol
        cell.priceLabel?.text = "$\(favList[indexPath.row].price)"
        cell.changeLabel?.text = favList[indexPath.row].change
        cell.changePercentLabel?.text = favList[indexPath.row].change_percent
        return cell
    }
    //MARK: - pickerView protocol methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return sortOptions.count
        case 1:
            return orderOptions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return sortOptions[row]
        case 1:
            return orderOptions[row]
        default:
            return nil
        }
    }
    
    //change the pickerView size
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont (name: "Helvetica Neue", size: 17)
        switch pickerView.tag {
        case 0:
            label.text =  sortOptions[row]
        case 1:
            label.text =  orderOptions[row]
        default:
            label.text = nil
        }
        label.textAlignment = .center
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            print(sortOptions[row])
            if row == 0 {
                orderPicker.isUserInteractionEnabled = false
            } else {
                orderPicker.isUserInteractionEnabled = true
            }
        case 1:
            print(orderOptions[row])
        default:
            print("Error")
        }
    }
    
    //MARK: -
    // dimiss the keyboard when touches outside textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input.resignFirstResponder()
        return false
    }
    
    //MARK: - button events
    @IBAction func getQueto(_ sender: Any) {
        guard let symbol = input.text?.trim() else{
            return
        }
        if symbol != "" {
            isInputEmpty = false
            print(symbol)
        } else {
            print("input is empty")
            isInputEmpty = true
            //show toast
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        input.text = ""
    }
    
    @IBAction func refresh(_ sender: Any) {
        favList = []
        fetchFavList(symbolList: symbolList) { (string) in
            print(string)
            print(self.favList)
            self.stockTableView.reloadData()
        }
    }
    
    //MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getQuote" {
            let symbol = input.text?.trim()
            (segue.destination as! ResultVC).symbol = symbol
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isInputEmpty {
            return false
        } else {
            return true
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        self.input.delegate = self
        sortPicker.dataSource = self
        sortPicker.delegate = self
        orderPicker.dataSource = self
        orderPicker.delegate = self
        
        orderPicker.isUserInteractionEnabled = false
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        favList = []
        symbolList = IO.object(forKey: "symbolList") as! [String]
        print(symbolList)
        fetchFavList(symbolList: symbolList) { (string) in
            print(string)
            print(self.favList)
            self.stockTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func fetchFavList(symbolList: [String], completion: @escaping (String) -> Void) {
        let count = symbolList.count
        var incrementor: Int = 0
        for symbol in symbolList {
            webService.getFavItem(symbol: symbol, completion: { (favItem) in
                self.favList.append(favItem)
                incrementor = incrementor + 1
                if count == incrementor {
                    completion("Success")
                }
            })
        }
    }
}

//MARK: -
class FavListTableCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
}

//MARK: -
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

