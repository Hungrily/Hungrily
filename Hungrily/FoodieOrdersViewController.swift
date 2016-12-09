//
//  FoodieOrdersViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 12/8/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FoodieOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders: [Order]!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchOrders()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orders = orders {
            return orders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.configureCell(order: orders[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func backToFoodieOrders(storyboard: UIStoryboardSegue) {}
    
    func fetchOrders() {
        dataBaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("orders").observe(.value, with: { (snapshot) in
            var results = [Order]()
            for orderId in snapshot.children {
                let orderObj = orderId as! FIRDataSnapshot
                let id = "\(orderObj.key)"
                self.dataBaseRef.child("orders").child(id).observe(.value, with: { (orderSnapshot) in
                    results.append(Order(snapshot: orderSnapshot))
                    self.orders = results.sorted(by: { (u1, u2) -> Bool in
                        u1.quantity < u2.quantity
                    })
                    self.tableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodieOrderDetailSegue" {
            let destination = segue.destination as! FoodieOrderDetailViewController
            destination.order = orders![(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
