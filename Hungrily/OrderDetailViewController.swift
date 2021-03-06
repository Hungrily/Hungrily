//
//  OrderDetailViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var foodiePhoto: UIImageView! {
        didSet {
            foodiePhoto.layer.cornerRadius = 10
            foodiePhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var recipePhoto: UIImageView! {
        didSet {
            recipePhoto.layer.cornerRadius = 10
            recipePhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var note: UITextView!
    
    var order: Order!
    var foodie: Foodie!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quantity.text = order.quantity!
        self.delivery.text = order.delivery!
        self.note.text = order.notes!
        loadRecipeInfo(id: order.recipeId!)
        loadFoodieInfo(id: order.foodieId!)
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
            self.foodie = Foodie(snapshot: snapshot)
            self.name.text = "\(self.foodie.firstName!) \(self.foodie.lastName!)"
            let imageURL = self.foodie.photoURL!
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
    
    @IBAction func backToOrderDetail(storyboard: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodieDetailSegue" {
            let destination = segue.destination as! FoodieDetailViewController
            destination.foodie = foodie
        }
    }

}
