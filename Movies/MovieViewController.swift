//
//  MovieViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import SideMenu
import Spring

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    //MARK: - Properties
    
    /*** Gradient and collectionView ***/
    @IBOutlet weak var gradientView: UIView!                    //View for the gradient
    @IBOutlet weak var movieCollectionView: UICollectionView!   //collection
    
    /*** Tab Menu ***/
    @IBOutlet weak var popularButton: UIButton!                 //Popular tab
    @IBOutlet weak var popularView: SpringView!                 //Represent the tab bar for popularButton
    @IBOutlet weak var upcomingButton: UIButton!                //Upcoming tab
    @IBOutlet weak var upcomingView: SpringView!                //Represent the tab bar for upcomingButton
    @IBOutlet weak var topRatedButton: UIButton!                //Top Rated tab
    @IBOutlet weak var topRatedView: SpringView!                //Represent the tab bar for topRatedButton
    
    /*** Gradient variable ***/
    var gradientLayer: CAGradientLayer! = CAGradientLayer()     //Variable for gradient background
    
    /*** Search Bar variables ***/
    var searchBar = UISearchBar()                               //Searchbar
    var menuButtonItem: UIBarButtonItem?                        //Item button which represents the menu
    var isSearching: Bool = false                               //To know if the user search
    
    /*** Tab Menu variables ***/
    var isPopular: Bool = true                                  //To know if popular is selected
    var isUpcoming: Bool = false                                //To know if upcoming is selected
    var isTopRated: Bool = false                                //To know if top rated is selected
    
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
        let gradientLayer = DisplayHelper.createGradientLayer(width: self.view.bounds.width, height: gradientView.bounds.height)
        gradientView.layer.addSublayer(gradientLayer)
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
        cell.moviePosterImageView.image = DisplayHelper.setImageFromURl(url: "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg")
        return cell
    }
    
    //MARK: - Actions
    
    //Selected Popular tab and display all populars movies
    @IBAction func popularAction(_ sender: Any) {
        isPopular = true
        
        popularButton.setTitleColor(UIColor.white, for: .normal)
        upcomingButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        topRatedButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isUpcoming {
            animateHiddenView(target: &isUpcoming, view: upcomingView)
        }
        else {
            animateHiddenView(target: &isTopRated, view: topRatedView)
        }
        
        animateShowView(view: popularView)
    }
    
    //Selected Upcoming tab and display all upcommings movies
    @IBAction func upcomingAction(_ sender: Any) {
        isUpcoming = true
        
        upcomingButton.setTitleColor(UIColor.white, for: .normal)
        popularButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        topRatedButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isPopular {
            animateHiddenView(target: &isPopular, view: popularView)
        }
        else {
            animateHiddenView(target: &isTopRated, view: topRatedView)
        }
        
        animateShowView(view: upcomingView)
    }
    
    //Selected Top Rated tab and display all top rated movies
    @IBAction func topRatedAction(_ sender: Any) {
        isTopRated = true
        
        topRatedButton.setTitleColor(UIColor.white, for: .normal)
        popularButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        upcomingButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isPopular {
            animateHiddenView(target: &isPopular, view: popularView)
        }
        else {
            animateHiddenView(target: &isUpcoming, view: upcomingView)
        }
        
        animateShowView(view: topRatedView)
    }
    
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
    
    //Animation for the view of tab needed to be hidden
    func animateHiddenView(target: inout Bool, view: SpringView) {
        target = false
        view.animation = "slideRight"
        view.duration = 1.0
        view.animate()
        view.isHidden = true
    }
    
    //Animation for the view of tab needed to be showed
    func animateShowView(view: SpringView) {
        view.isHidden = false
        view.animation = "slideRight"
        view.duration = 1.0
        view.animate()
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
