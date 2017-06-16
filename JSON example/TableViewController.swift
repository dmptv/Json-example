//
//  TableViewController.swift
//  JSON example
//
//  Created by Kanat A on 15/06/2017.
//  Copyright © 2017 ak. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let kivaLoadURL = "https://api.kivaws.org/v1/loans/newest.json"
    var loans = [Loan]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLatestLoans() 
        
        // настроим самомасшабирование высоты ячейки
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let loan = loans[indexPath.row]
        cell.amountLabel.text = "$\(loan.amount)"
        cell.nameLabel.text = loan.name
        cell.countryLabel.text = loan.country
        cell.useLabel.text  = loan.use

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120.0
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

 
    func getLatestLoans() {
        // Request
        let request = URLRequest(url: URL(string: kivaLoadURL)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error")
                return
            }
            
            // Parsing
            if let data = data {
                self.loans = self.parseJsondata(data: data)
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    // Parse JSON Data
    func parseJsondata(data: Data) -> [Loan] {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            
            for jsonLoan in jsonLoans {
                let loan = Loan()
                loan.name = jsonLoan["name"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                loan.use = jsonLoan["use"] as! String
                let location = jsonLoan["location"] as! [String : Any]
                loan.country = location["country"] as! String
                loans.append(loan)
            }
        } catch {
            print("Error")
        }
        return loans
    }

 
}

















