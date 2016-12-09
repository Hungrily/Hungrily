//
//  Order.swift
//  Hungrily
//
//  Created by Akash Ungarala on 12/4/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Order {
    
    var ref: FIRDatabaseReference?
    var uid: String!
    var key: String?
    var chefId: String!
    var foodieId: String!
    var recipeId: String!
    var quantity: String!
    var delivery: String!
    var notes: String!
    var totalPrice: String!
    var taxAmount: String!
    var totalAmount: String!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        uid = (snapshot.value! as! NSDictionary)["uid"] as! String
        chefId = (snapshot.value! as! NSDictionary)["chefId"] as! String
        foodieId = (snapshot.value! as! NSDictionary)["foodieId"] as! String
        recipeId = (snapshot.value! as! NSDictionary)["recipeId"] as! String
        quantity = (snapshot.value! as! NSDictionary)["quantity"] as! String
        delivery = (snapshot.value! as! NSDictionary)["delivery"] as! String
        notes = (snapshot.value! as! NSDictionary)["notes"] as! String
        totalPrice = (snapshot.value! as! NSDictionary)["totalPrice"] as! String
        taxAmount = (snapshot.value! as! NSDictionary)["taxAmount"] as! String
        totalAmount = (snapshot.value! as! NSDictionary)["totalAmount"] as! String
    }
    
}
