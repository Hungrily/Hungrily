//
//  FoodieOrderDetailViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 12/8/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FoodieOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var chefPhoto: UIImageView! {
        didSet {
            chefPhoto.layer.cornerRadius = 10
            chefPhoto.clipsToBounds = true
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
    var chef: Chef!
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
        loadChefInfo(id: order.chefId!)
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
    
    func loadChefInfo(id: String) {
        let userRef = dataBaseRef.child("users/\(id)")
        userRef.observe(.value, with: { (snapshot) in
            self.chef = Chef(snapshot: snapshot)
            self.name.text = "\(self.chef.firstName!) \(self.chef.lastName!)"
            let imageURL = self.chef.photoURL!
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
    
    @IBAction func backToFoodieOrderDetail(storyboard: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderChefDetailSegue" {
            let destination = segue.destination as! ChefDetailViewController
            destination.sender = "Foodie"
            destination.chef = chef
        }
    }
    
}
