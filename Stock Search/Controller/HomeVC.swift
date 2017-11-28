//
//  ViewController.swift
//  Stock Search
//
//  Created by David on 11/20/17.
//  Copyright © 2017 Jikun. All rights reserved.
//

import UIKit
import EasyToast
import SearchTextField

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var stockTableView: UITableView!
    @IBOutlet weak var autoRefresh: UISwitch!
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var orderPicker: UIPickerView!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var getQuoteBtn: UIButton!
    
    var actIndicatior: UIActivityIndicatorView = UIActivityIndicatorView()
    var timer: Timer!
    
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
        
        let charset = CharacterSet(charactersIn: "-")
        if (cell.changeLabel.text?.rangeOfCharacter(from: charset) != nil) {
            cell.changeLabel.textColor = UIColor.red
            cell.changePercentLabel.textColor = UIColor.red
        } else {
            cell.changeLabel.textColor = UIColor.green
            cell.changePercentLabel.textColor = UIColor.green
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultVC") as! ResultVC
        resultVC.symbol = favList[indexPath.row].symbol
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemForDelete = favList[indexPath.row]
            print("deleted\(itemForDelete)")
            let index = symbolList.index(of: itemForDelete.symbol!)
            symbolList.remove(at: index!)
            IO.set(symbolList, forKey: "symbolList")
            self.favList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
    
    //MARK: - keyboard event
    // dimiss the keyboard when touches outside textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input.resignFirstResponder()
        return false
    }
    
    //MARK: - autocomplete
    @IBAction func inputChanged(_ sender: SearchTextField) {
        print("typed")
    }
    
    //MARK: - button events
    @IBAction func getQueto(_ sender: Any) {
        guard let symbol = input.text?.trim().uppercased() else{
            return
        }
        if symbol != "" {
            isInputEmpty = false
            print(symbol)
        } else {
            print("input is empty")
            isInputEmpty = true
            self.view.showToast("Please enter a stock name or symbol", position: .bottom, popTime: 5, dismissOnTap: false)
            //show toast
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        input.text = ""
    }
    
    @IBAction func refresh(_ sender: Any) {
        refreshList()
    }
    
    @objc func refreshList() {
        actIndicatior.startAnimating()
        favList = []
        fetchFavList(symbolList: symbolList) { (string) in
            print(string)
            print(self.favList)
            self.stockTableView.reloadData()
            self.actIndicatior.stopAnimating()
        }
    }
    
    //MARK: - switch event
    @IBAction func toggleAutoRefresh(_ sender: UISwitch) {
        if sender.isOn {
            print("switch on")
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshList), userInfo: nil, repeats: true)
        } else {
            print("switch of")
            timer.invalidate()
        }
    }
    
    //MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getQuote" {
            let symbol = input.text?.trim().uppercased()
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
        
        if let x = IO.object(forKey: "symbolList") as? [String]{
            symbolList = x
        }
        print(symbolList)
        refreshList()
        // clean highlighted selected row
        let selectedRow: IndexPath? = stockTableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            stockTableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
        
        // init actindicator
        actIndicatior.center = stockTableView.center
        actIndicatior.hidesWhenStopped = true
        actIndicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actIndicatior.color = UIColor.green
        self.view.addSubview(actIndicatior)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func fetchFavList(symbolList: [String], completion: @escaping (String) -> Void) {
        let count = symbolList.count
        guard count != 0 else {
            completion("List Empty")
            return
        }
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

