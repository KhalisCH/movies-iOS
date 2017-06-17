//
//  AccountViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring

class AccountViewController: UIViewController {

    //MARK: - Properties
    
    //Connection
    @IBOutlet weak var connectionView: SpringView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Inscription
    @IBOutlet weak var inscriptionView: SpringView!
    @IBOutlet weak var emailTextField2: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TextFieldDelegate
    
    //MARK: - Actions
    
    @IBAction func connectionAction(_ sender: Any) {
        if !connectionView.isHidden {
            //Connect the user
            print("Connect")
            return
        }
        inscriptionView.animation = "fadeOut"
        inscriptionView.duration = 3.0
        inscriptionView.animate()
        inscriptionView.isHidden = true
        connectionView.isHidden = false
        connectionView.animation = "fadeIn"
        connectionView.duration = 3.0
        connectionView.animate()
    }
    
    @IBAction func inscriptionAction(_ sender: Any) {
        if !inscriptionView.isHidden {
            //Register the user
            print("Register")
            return
        }
        connectionView.animation = "fadeOut"
        connectionView.duration = 3.0
        connectionView.animate()
        connectionView.isHidden = true
        inscriptionView.isHidden = false
        inscriptionView.animation = "fadeIn"
        inscriptionView.duration = 3.0
        inscriptionView.animate()
    }
}
