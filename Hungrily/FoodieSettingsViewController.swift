//
//  FoodieSettingsViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FoodieSettingsViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = avatar.frame.size.width / 2
            avatar.clipsToBounds = true
        }
    }
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var changeFirstName: UIButton!
    @IBOutlet weak var newFirstName: UITextField!
    @IBOutlet weak var saveFirstName: UIButton!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var changeLastName: UIButton!
    @IBOutlet weak var newLastName: UITextField!
    @IBOutlet weak var saveLastName: UIButton!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var savePassword: UIButton!
    @IBOutlet weak var biography: UITextView!
    @IBOutlet weak var changeBiography: UIButton!
    @IBOutlet weak var newBiography: UITextField!
    @IBOutlet weak var saveBiography: UIButton!
    
    var foodie: Foodie!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.isHidden = false
        changeFirstName.isHidden = false
        newFirstName.isHidden = true
        saveFirstName.isHidden = true
        lastName.isHidden = false
        changeLastName.isHidden = false
        newLastName.isHidden = true
        saveLastName.isHidden = true
        password.isHidden = false
        changePassword.isHidden = false
        newPassword.isHidden = true
        savePassword.isHidden = true
        biography.isHidden = false
        changeBiography.isHidden = false
        newBiography.isHidden = true
        saveBiography.isHidden = true
        firstName.text = foodie.firstName!
        lastName.text = foodie.lastName!
//        password.text = foodie.firstName!
        biography.text = foodie.biography!
        let imageURL = self.foodie.photoURL!
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
    
    @IBAction func changeFirstNameValue(_ sender: UIButton) {
        firstName.isHidden = true
        changeFirstName.isHidden = true
        newFirstName.isHidden = false
        saveFirstName.isHidden = false
        newFirstName.text = foodie.firstName!
    }
    
    @IBAction func saveFirstNameValue(_ sender: UIButton) {
        firstName.isHidden = false
        changeFirstName.isHidden = false
        newFirstName.isHidden = true
        saveFirstName.isHidden = true
    }
    
    @IBAction func changeLastNameValue(_ sender: UIButton) {
        lastName.isHidden = true
        changeLastName.isHidden = true
        newLastName.isHidden = false
        saveLastName.isHidden = false
        newLastName.text = foodie.lastName!
    }
    
    @IBAction func saveLastNameValue(_ sender: UIButton) {
        lastName.isHidden = false
        changeLastName.isHidden = false
        newLastName.isHidden = true
        saveLastName.isHidden = true
    }
    
    @IBAction func changePasswordValue(_ sender: UIButton) {
        password.isHidden = true
        changePassword.isHidden = true
        newPassword.isHidden = false
        savePassword.isHidden = false
//        newPassword.text = foodie.firstName!
    }
    
    @IBAction func savePasswordValue(_ sender: UIButton) {
        password.isHidden = false
        changePassword.isHidden = false
        newPassword.isHidden = true
        savePassword.isHidden = true
    }
    
    @IBAction func changeBiographyValue(_ sender: UIButton) {
        biography.isHidden = true
        changeBiography.isHidden = true
        newBiography.isHidden = false
        saveBiography.isHidden = false
        newBiography.text = foodie.biography!
    }
    
    @IBAction func saveBiographyValue(_ sender: UIButton) {
        biography.isHidden = false
        changeBiography.isHidden = false
        newBiography.isHidden = true
        saveBiography.isHidden = true
    }

}
