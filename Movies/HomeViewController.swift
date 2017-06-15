//
//  HomeViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    @IBOutlet weak var gradientView: UIView!                    //View for the gradient
    @IBOutlet weak var movieCollectionView: UICollectionView!   //CollectionView for the movies
    @IBOutlet weak var tvCollectionView: UICollectionView!      //CollectionView for the tv shows
    
    var gradientLayer: CAGradientLayer! = CAGradientLayer()     //Variable for gradient background
    var moviePosters: [String] = []                             //Array of posters url for movies
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
    }
    
    //Display gradient
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    //MARK: - CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === movieCollectionView {
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
            cell.moviePosterImageView.image = setImageFromURl(url: "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg")
            return cell
        }
        else {
            let cell: TVCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! TVCollectionViewCell
            cell.tvPosterImageView.image = setImageFromURl(url: "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg")
            return cell
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
    
    //MARK: - Functions
    
    //Create and setting the gradient
    func createGradientLayer() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: gradientView.bounds.height)
        let firstColor = UIColor.init(hex: "#6684a3")
        let secondColor = UIColor.init(hex: "#325b84")
        let thirdColor = UIColor.init(hex: "#003366")
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.locations = [0.0, 0.3, 0.75]
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    //Set an image from URL
    func setImageFromURl(url: String) -> UIImage {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        return UIImage()
    }
}
