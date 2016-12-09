//
//  FoodieDetailViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FoodieDetailViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = avatar.frame.size.width / 2
            avatar.clipsToBounds = true
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var biography: UITextView!
    
    var foodie: Foodie!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "\(foodie.firstName!) \(foodie.lastName!)"
        biography.text = foodie.biography!
        let imageURL = foodie.photoURL!
        self.storageRef.reference(forURL: imageURL).data(withMaxSize: 10*1024*1024, completion: { (imgData, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.avatar.image = UIImage(data: data)
                    }
                }
            } else {
                self.avatar.image = UIImage(named: "Default Avatar")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}

}
