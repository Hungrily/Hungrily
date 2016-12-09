//
//  OrderCell.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var recipePhoto: UIImageView! {
        didSet {
            recipePhoto.layer.cornerRadius = 10
            recipePhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var foodiePhoto: UIImageView! {
        didSet {
            foodiePhoto.layer.cornerRadius = 10
            foodiePhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var chefPhoto: UIImageView! {
        didSet {
            chefPhoto.layer.cornerRadius = 10
            chefPhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(order: Order) {
        self.quantity.text = order.quantity!
        self.deliveryTime.text = order.delivery!
        loadRecipeInfo(id: order.recipeId!)
        if foodiePhoto != nil {
            loadFoodieInfo(id: order.foodieId!)
        }
        if chefPhoto != nil {
            loadChefInfo(id: order.chefId!)
        }
    }
    
    func loadRecipeInfo(id: String) {
        let recipeRef = dataBaseRef.child("recipes/\(id)")
        recipeRef.observe(.value, with: { (snapshot) in
            let recipe = Recipe(snapshot: snapshot)
            self.recipeTitle.text = recipe.title!
            let imageURL = recipe.photoURL!
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.recipePhoto.image = UIImage(data: data)
                        }
                    }
                } else {
                    self.recipePhoto.image = UIImage(named: "Foodie")
                }
            })
        }) { (error) in
            self.recipePhoto.image = UIImage(named: "Foodie")
        }
    }
    
    func loadFoodieInfo(id: String) {
        let userRef = dataBaseRef.child("users/\(id)")
        userRef.observe(.value, with: { (snapshot) in
            let foodie = Foodie(snapshot: snapshot)
            self.name.text = "\(foodie.firstName!) \(foodie.lastName!)"
            let imageURL = foodie.photoURL!
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.foodiePhoto.image = UIImage(data: data)
                        }
                    }
                } else {
                    self.foodiePhoto.image = UIImage(named: "Default Avatar")
                }
            })
        }) { (error) in
            self.foodiePhoto.image = UIImage(named: "Default Avatar")
        }
    }
    
    func loadChefInfo(id: String) {
        let userRef = dataBaseRef.child("users/\(id)")
        userRef.observe(.value, with: { (snapshot) in
            let chef = Chef(snapshot: snapshot)
            self.name.text = "\(chef.firstName!) \(chef.lastName!)"
            let imageURL = chef.photoURL!
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.chefPhoto.image = UIImage(data: data)
                        }
                    }
                } else {
                    self.chefPhoto.image = UIImage(named: "Chef")
                }
            })
        }) { (error) in
            self.chefPhoto.image = UIImage(named: "Chef")
        }
    }

}
