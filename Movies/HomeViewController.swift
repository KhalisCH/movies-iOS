//
//  HomeViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Properties
    
    //View for the gradient
    @IBOutlet weak var gradientView: UIView!
    
    //Variable for gradient background
    var gradientLayer: CAGradientLayer! = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Display gradient
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Functions
    
    //Create and setting the gradient
    func createGradientLayer() {
        gradientLayer.frame = self.view.bounds
        let firstColor = UIColor.init(hex: "#6684a3")
        let secondColor = UIColor.init(hex: "#325b84")
        let thirdColor = UIColor.init(hex: "#003366")
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.locations = [0.0, 0.3, 0.75]
        gradientView.layer.addSublayer(gradientLayer)
    }

}
