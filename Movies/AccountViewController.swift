//
//  AccountViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring
import Alamofire
import SwiftyJSON

class AccountViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    //Connection
    @IBOutlet weak var connectionView: SpringView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Inscription
    @IBOutlet weak var inscriptionView: SpringView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField2: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.delegate = self
        usernameTextField2.delegate = self
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
            connection()
            return
        }
        animateView(firstView: inscriptionView, secondView: connectionView)
    }
    
    //Register the user or display connectionView
    @IBAction func inscriptionAction(_ sender: Any) {
        if !inscriptionView.isHidden {
            inscription(sender: sender)
            return
        }
        animateView(firstView: connectionView, secondView: inscriptionView)
    }
    
    //Dismmiss keyboard when the user tap anywhere
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    //Perform segue to go back home when item bar button is tapped
    @IBAction func goBackToHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    //MARK: - Functions
    
    //Check if the user has an account and load his data
    func connection() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(MoviesRouter.connection(username: usernameTextField.text!, password: passwordTextField.text!)).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while trying to connect user on Account: \(response.result.error)")
                return
            }
            switch(response.response?.statusCode) {
            case 200?:
                let json = JSON(response.result.value!)
                let defaults = UserDefaults.standard
                defaults.set(json["userId"].intValue, forKey: "userID")
                defaults.set(json["username"].stringValue, forKey: "username")
                defaults.set(true, forKey: "isConnected")
                defaults.synchronize()
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                break
            case 400?:
                print("Veuillez remplir tous les champs")
                break
            case 403?:
                print("Mot de passe ou identifiant incorrecte")
                break
            case 404?:
                print("Cet utilisateur n'existe pas")
                break
            case 500?:
                print("Veuillez vérifier votre connexion internet")
                break
            default:
                print("Autres")
                return
            }
        }
    }
    
    //Save the user in the bdd
    func inscription(sender: Any) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(MoviesRouter.inscription(email: emailTextField.text!, username: usernameTextField2.text!, password: passwordTextField2.text!)).responseString { response in
            guard response.result.isSuccess else {
                print("Error while trying to register user on Account: \(response.result.error)")
                return
            }
            switch(response.response?.statusCode) {
            case 200?:
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                self.connectionAction(sender)
                break
            case 400?:
                print("Veuillez remplir tous les champs")
                break
            case 403?:
               print("Mot de passe ou identifiant incorrecte")
                break
            case 404?:
                print("Cet utilisateur n'existe pas")
                break
            case 500?:
                print("Veuillez vérifier votre connexion internet")
                break
            default:
                print("Autres")
                return
            }
        }
    }
    
    //Animate the views to show and hide
    func animateView(firstView: SpringView, secondView: SpringView) {
        firstView.animation = "fadeOut"
        firstView.duration = 3.0
        firstView.animate()
        firstView.isHidden = true
        secondView.isHidden = false
        secondView.animation = "fadeIn"
        secondView.duration = 3.0
        secondView.animate()
    }
}
