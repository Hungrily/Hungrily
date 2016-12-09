//
//  RecipeCell.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = 10
            avatar.clipsToBounds = true
        }
    }
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = 10
            photo.clipsToBounds = true
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    
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
    
    func configureCell(recipe: Recipe) {
        self.recipeTitle.text = recipe.title!
        self.cuisine.text = recipe.cuisine!
        self.category.text = recipe.category!
        self.price.text = "\(recipe.price!) $"
        self.ingredients.text = recipe.ingredients!
        if name != nil {
            loadChefInfo(id: recipe.chefId!)
        }
        let imageURL = recipe.photoURL!
        self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.photo.image = UIImage(data: data)
                    }
                }
            } else {
                self.photo.image = UIImage(named: "Foodie")
            }
        })
    }
    
    func loadChefInfo(id: String) {
        let userRef = dataBaseRef.child("users/\(id)")
        userRef.observe(.value, with: { (snapshot) in
            let chef = Chef(snapshot: snapshot)
            self.name.text = "\(chef.firstName!) \(chef.lastName!)"
            self.address.text = "\(chef.city!), \(chef.country!)"
            self.availability.text = chef.availability!
            let imageURL = chef.photoURL!
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.avatar.image = UIImage(data: data)
                        }
                    }
                } else {
                    self.avatar.image = UIImage(named: "Chef")
                }
            })
        }) { (error) in
            self.avatar.image = UIImage(named: "Chef")
        }
    }

}
