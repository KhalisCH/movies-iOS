//
//  MovieViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import SideMenu

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var gradientView: UIView!                    //View for the gradient
    @IBOutlet weak var movieCollectionView: UICollectionView!   //collection
    
    var gradientLayer: CAGradientLayer! = CAGradientLayer()     //Variable for gradient background
    
    var searchBar = UISearchBar()                               //Searchbar
    var menuButtonItem: UIBarButtonItem?                        //Item button which represents the menu
    var isSearching: Bool = false                               //To know if the user search
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        menuButtonItem = navigationItem.leftBarButtonItem
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    //Display gradient
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    //MARK: - CollectionViewDelegate
    
    //Number of elements of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    //Number of sections of the collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Treatment on the cells of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.moviePosterImageView.image = setImageFromURl(url: "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg")
        return cell
    }
    
    //MARK: - Actions
    
    //Show or hide the search bar
    @IBAction func searchAction(_ sender: Any) {
        if !isSearching {
            showSearchBar()
        }
        else {
            hideSearchBar()
        }
    }
    
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
    
    //Show the search bar
    func showSearchBar() {
        isSearching = true
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: false)
        searchBar.alpha = 1
        searchBar.becomeFirstResponder()
    }
    
    //Hide the search bar
    func hideSearchBar() {
        isSearching = false
        navigationItem.setLeftBarButton(menuButtonItem, animated: true)
        navigationItem.titleView = nil
    }
}
