//
//  SampleTableViewController.swift
//  alamofireApp
//
//  Created by Damirka on 25.11.2022.
//

import UIKit
import Alamofire

class SampleTableViewController: UITableViewController {
    
    var array = [String]()
    let url = "http://api.apilayer.com/exchangerates_data/latest"
    let key = "EN3auT1qK2jNf3l14fLj6Rk3U1J2RP62"
    let base = "EUR"
    let symbols = "RUB,USD,GBP,JPY,CHF,CAD,AUD,MXN,INR,BRL"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = [
            "apikey": key,
            "base": base,
            "symbols": symbols
        ]
        
        getPrice(url: url, parameters: parameters)
    }
    
    func getPrice(url: String, parameters: [String: Any]) {
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard
                let self = self,
                let data = response.data,
                let ratesData = try? JSONDecoder().decode(RatesData.self, from: data)
            else { return }

            self.title = ratesData.base
            self.generatePrices(from: ratesData.rates)
            self.tableView.reloadData()
        }
    }
    
    func generatePrices(from rates: [String: Double]) {
        for (name, price) in rates {
            array.append(("\(name) : \(price)"))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sample_cell", for: indexPath)

        cell.textLabel?.text = array[indexPath.row]

        return cell
    }
}
