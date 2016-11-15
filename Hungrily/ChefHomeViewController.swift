//
//  ChefHomeViewController.swift
//  Hungrily
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChefHomeViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        if FIRAuth.auth()!.currentUser != nil {
            // there is a user signed in
            do {
                try? FIRAuth.auth()!.signOut()
                if FIRAuth.auth()?.currentUser == nil {
                    let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.present(HomeViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backToChefHome(storyboard: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}

}
