//
//  AccountViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring

class AccountViewController: UIViewController, UITextFieldDelegate {

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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField2.delegate = self
        usernameTextField.delegate = self
        passwordTextField2.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //MARK: - TextFieldDelegate
    
    //Dismiss keyboard when user tap on 'Done'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Actions
    
    //Connect the user or display inscriptionView
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
    
    //Register the user or display connectionView
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
    
    //Dismmiss keyboard when the user tap anywhere
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func goBackToHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    //MARK: - Functions
}
