//
//  ProfileViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class ProfileViewController: UINavigationController {

    //MARK: - Properties
    
    
    
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Display login page if the user is not connected favorite else
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isConnected {
            performSegue(withIdentifier: "connectionSegue", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
