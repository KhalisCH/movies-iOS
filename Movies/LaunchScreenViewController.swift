//
//  LaunchScreenViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring

class LaunchScreenViewController: UIViewController {

    //MARK: - Properties
    
    //Label of splashScreen
    @IBOutlet weak var moviesLabel: SpringLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Perform segue when animation is finished
        moviesLabel.animateNext {
            self.performSegue(withIdentifier: "homeSegue", sender: self)
        }
    }
}
