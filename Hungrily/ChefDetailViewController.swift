//
//  ChefDetailViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ChefDetailViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = 10
            avatar.clipsToBounds = true
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var biography: UITextView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var backToChefs: UIButton!
    @IBOutlet weak var backToFoodieOrderDetail: UIButton!
    
    var chef: Chef!
    var sender: String!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.sender == "Chef" {
            backToChefs.isHidden = false
            backToFoodieOrderDetail.isHidden = true
        } else if self.sender == "Foodie" {
            backToChefs.isHidden = true
            backToFoodieOrderDetail.isHidden = false
        }
        self.name.text = "\(chef.firstName!) \(chef.lastName!)"
        self.biography.text = chef.biography!
        self.address.text = chef.address!
        self.city.text = chef.city!
        self.country.text = chef.country!
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
    }
    
    @IBAction func backToChefDetail(storyboard: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChefRecipesSegue" {
            let destination = segue.destination as! ChefRecipesViewController
            destination.chef = chef
        }
    }

}
