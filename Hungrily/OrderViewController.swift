//
//  OrderViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/18/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class OrderViewController: UIViewController {
    
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
    @IBOutlet weak var pickUpTime: UITextField! {
        didSet {
            pickUpTime.delegate = self
            pickUpTime.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var quantity: UITextField! {
        didSet {
            quantity.delegate = self
            quantity.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var note: UITextField! {
        didSet {
            note.delegate = self
            note.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var taxAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var recipe: Recipe!
    var price: Double! {
        didSet {
            price = Double(round(100*price)/100)
        }
    }
    var tax: Double! {
        didSet {
            tax = Double(round(100*tax)/100)
        }
    }
    var total: Double! {
        didSet {
            total = Double(round(100*total)/100)
        }
    }
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureRecognizersToDismissKeyboard()
        loadChefInfo(id: recipe.chefId!)
        self.recipeTitle.text = recipe.title!
        self.unitPrice.text = "\(recipe.price!) $"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.quantity.text = nil
        price = 0.00
        tax = 0.00
        total = 0.00
        setValues(quantity: 0)
        _ = isValid()
    }
    
    @IBAction func placeOrder(_ sender: UIButton) {
        let chefId = recipe.chefId!
        let recipeId = recipe.uid!
        let qty = quantity.text!
        let delivery = pickUpTime.text!
        let notes = note.text!
        if qty.isEmpty {
            self.view.endEditing(true)
            showMessage(message: "Quantity is a mandatory field")
        } else if delivery.isEmpty {
            self.view.endEditing(true)
            showMessage(message: "Pick-Up Time is a mandatory field")
        } else if notes.isEmpty {
            self.view.endEditing(true)
            showMessage(message: "Note is a mandatory field")
        } else {
            self.view.endEditing(true)
            createOrder(chefId: chefId, recipeId: recipeId, quantity: qty, delivery: delivery, notes: notes, totalPrice: "\(price!)", taxAmount: "\(tax!)", totalAmount: "\(total!)")
        }
    }
    
    @IBAction func quantityChanged(_ sender: UITextField) {
        if (isValid() == true) {
            let qty = Int(self.quantity.text!)!
            if (qty > 20) {
                self.quantity.text = "20"
                self.setValues(quantity: 20)
                self.showMessage(message: "For an order, quantity is limited to 20!")
            } else {
                self.quantity.text = "\(qty)"
                self.setValues(quantity: qty)
            }
        } else {
            self.quantity.text = nil
            setValues(quantity: 0)
        }
    }
    
    func setValues(quantity: Int) {
        let unitPrice = Double(self.recipe.price!)!
        price = unitPrice * Double("\(quantity)")!
        tax = price * 0.05
        total = price + tax
        self.totalPrice.text = "\(price!) $"
        self.taxAmount.text = "\(tax!) $"
        self.totalAmount.text = "\(total!) $"
    }
    
    func createOrder(chefId: String!, recipeId: String, quantity: String, delivery: String, notes: String, totalPrice: String, taxAmount: String, totalAmount: String) {
        let id = self.dataBaseRef.child("orders").childByAutoId().key
        let orderInfo = ["foodieId": FIRAuth.auth()!.currentUser!.uid, "chefId": chefId, "recipeId": recipeId, "quantity": quantity, "delivery": delivery, "notes": notes, "uid": id, "totalPrice": totalPrice, "taxAmount": taxAmount, "totalAmount": totalAmount]
        let orderRef = self.dataBaseRef.child("orders").child(id)
        orderRef.setValue(orderInfo) { (error, ref) in
            if error == nil {
                let chefRef = self.dataBaseRef.child("users").child(chefId).child("orders").child(id)
                chefRef.setValue(id) { (error, ref) in
                    if error == nil {
                        let foodieRef = self.dataBaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("orders").child(id)
                        foodieRef.setValue(id) { (error, ref) in
                            if error == nil {
                                self.performSegue(withIdentifier: "backToFoodieHome", sender: nil)
                            }
                        }
                    }
                }
            }
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
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValid() -> Bool {
        var isValid = false
        if let text = self.quantity.text , !text.isEmpty {
            if Int(text) != nil {
                if (Int(text)! != 0) {
                    isValid = true
                }
            }
        }
        return isValid
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "backToFoodieHome" {
            return false
        }
        return true
    }

}

extension OrderViewController: UITextFieldDelegate  {
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pickUpTime.resignFirstResponder()
        quantity.resignFirstResponder()
        note.resignFirstResponder()
        return true
    }
    
    // Moving the View down after the Keyboard appears
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        animateView(up: true, moveValue: 80)
    }
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(_ textField: UITextField) {
//        animateView(up: false, moveValue: 80)
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat) {
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func setGestureRecognizersToDismissKeyboard() {
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard(gesture:)))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
    }
    
}
