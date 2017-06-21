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
import Alamofire
import SwiftyJSON

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    //MARK: - Properties
    
    /*** Loading indicator ***/
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
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
    
    /*** Id variable and data ***/
    var movieSelected: Int? = nil                               //Id of the selected movie
    var movieData: [JSON] = []                                  //Array of posters url andvar of movies
    var page: Int = 1                                           //Number of the page we want
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovies(request: MovieDatabaseRouter.popularMovie(language: "en-US", page: page))
        
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
    
    // MARK: - Navigation
    
    //Pass infromation to the destination view controller before perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailsSegue" {
            let controller = segue.destination as! MovieDetailsViewController
            controller.movieId = movieSelected
        }
    }
    
    //MARK: - CollectionViewDelegate
    
    //Number of elements of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    //Number of sections of the collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Treatment on the cells of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        guard !movieData[indexPath.row]["posterURL"].stringValue.isEmpty else {
            cell.moviePosterImageView.image = UIImage(named: "iosLogo")
            cell.moviePosterImageView.contentMode = .scaleAspectFit
            return cell
        }
        cell.moviePosterImageView.image = DisplayHelper.setImageFromURl(url: movieData[indexPath.row]["posterURL"].stringValue)
        return cell
    }
    
    //Perform segue when user tap on a collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieSelected = movieData[indexPath.row]["id"].intValue
        performSegue(withIdentifier: "movieDetailsSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieData.count - 1 {
            page = page + 1
            if isPopular {
                getMovies(request: MovieDatabaseRouter.popularMovie(language: "en-US", page: page))
            }
            else if isUpcoming {
                getMovies(request: MovieDatabaseRouter.nowPlayingMovie(language: "en-US", page: page))
            }
            else if isTopRated {
                getMovies(request: MovieDatabaseRouter.topRatedMovie(language: "en-US", page: page))
            }
        }
    }
    
    //MARK: - Actions
    
    //Selected Popular tab and display all populars movies
    @IBAction func popularAction(_ sender: Any) {
        page = 1
        getMovies(request: MovieDatabaseRouter.popularMovie(language: "en-US", page: page))
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
        page = 1
        getMovies(request: MovieDatabaseRouter.nowPlayingMovie(language: "en-US", page: page))
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
        page = 1
        getMovies(request: MovieDatabaseRouter.topRatedMovie(language: "en-US", page: page))
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
    
    /*** HTTP Request ***/
    //Get popular or now playing or top rated movies and push information in the movieData array
    func getMovies(request: MovieDatabaseRouter) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(request).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching upcoming movies on Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            self.movieData = []
            for i in 0..<20 {
                let obj: JSON = ["id": json["results"][i]["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + json["results"][i]["poster_path"].stringValue]
                self.movieData.append(obj)
            }
            self.movieCollectionView.reloadData()
            self.movieCollectionView.contentOffset = CGPoint.zero
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    /*** Animations ***/
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
