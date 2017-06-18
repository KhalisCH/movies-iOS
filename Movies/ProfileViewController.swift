//
//  ProfileViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring

class ProfileViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var myMovieButton: UIButton!
    @IBOutlet weak var myTvShowButton: UIButton!
    @IBOutlet weak var myMovieView: SpringView!
    @IBOutlet weak var myTvShowView: SpringView!
    
    var isConnected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Display login page if the user is not connected favorite else
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isConnected {
            performSegue(withIdentifier: "connectionSegue", sender: self)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func myMovieAction(_ sender: Any) {
        myMovieButton.setTitleColor(UIColor.white, for: .normal)
        myTvShowButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        myTvShowView.animation = "slideRight"
        myTvShowView.duration = 1.0
        myTvShowView.animate()
        myTvShowView.isHidden = true
        myMovieView.isHidden = false
        myMovieView.animation = "slideRight"
        myMovieView.duration = 1.0
        myMovieView.animate()
    }
    
    @IBAction func myTvShowAction(_ sender: Any) {
        myTvShowButton.setTitleColor(UIColor.white, for: .normal)
        myMovieButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        myMovieView.animation = "slideLeft"
        myMovieView.duration = 1.0
        myMovieView.animate()
        myMovieView.isHidden = true
        myTvShowView.isHidden = false
        myTvShowView.animation = "slideLeft"
        myTvShowView.duration = 1.0
        myTvShowView.animate()
    }
}
