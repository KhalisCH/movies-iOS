//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    //MARK: - Properties
    var isFavorite: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func goBackToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        if isFavorite {
            isFavorite = false
            navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_empty_favorite_24pt")
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
        else {
            isFavorite = true
            navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_plain_favorite_24pt")
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 212/255, green: 67/255, blue: 74/255, alpha: 1.0)
        }
    }
}
