//
//  TVShowViewController.swift
//  Movies
//
//  Created by Khalis on 19/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import SideMenu
import Spring
import Alamofire
import SwiftyJSON

class TVShowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    /*** CollectionView ***/
    @IBOutlet weak var tvShowCollectionView: UICollectionView!   //collection
    
    /*** Tab Menu ***/
    @IBOutlet weak var popularButton: UIButton!                 //Popular tab
    @IBOutlet weak var popularView: SpringView!                 //Represent the tab bar for popularButton
    @IBOutlet weak var recentButton: UIButton!                  //Recent tab
    @IBOutlet weak var recentView: SpringView!                  //Represent the tab bar for recentButton
    @IBOutlet weak var topRatedButton: UIButton!                //Top Rated tab
    @IBOutlet weak var topRatedView: SpringView!                //Represent the tab bar for topRatedButton
    
    /*** Search Bar variables ***/
    var searchBar = UISearchBar()                               //Searchbar
    var menuButtonItem: UIBarButtonItem?                        //Item button which represents the menu
    var isSearching: Bool = false                               //To know if the user search
    var performSearch: Bool = false                             //To know if the user execute a search
    
    /*** Tab Menu variables ***/
    var isPopular: Bool = true                                  //To know if popular is selected
    var isRecent: Bool = false                                  //To know if recent is selected
    var isTopRated: Bool = false                                //To know if top rated is selected
    
    /*** Id variable and data ***/
    var tvShowSelected: Int? = nil                              //Id of the selected TV show
    var tvShowData: [JSON] = []                                 //Array of posters url and id of TV show
    var page: Int = 1                                           //Number of the page we want
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTvShows(request: MovieDatabaseRouter.popularTvShow(language: "en-US", page: page))
        
        tvShowCollectionView.delegate = self
        tvShowCollectionView.dataSource = self
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        menuButtonItem = navigationItem.leftBarButtonItem
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    // MARK: - Navigation
    
    //Pass infromation to the destination view controller before perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tvShowDetailsSegue" {
            let controller = segue.destination as! TVShowDetailsViewController
            controller.tvShowId = tvShowSelected
        }
    }
    
    //MARK: - CollectionViewDelegate
    
    //Number of elements of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShowData.count
    }
    
    //Number of sections of the collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Treatment on the cells of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TVCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! TVCollectionViewCell
        if !tvShowData[indexPath.row]["posterURL"].stringValue.isEmpty {
            guard !tvShowData[indexPath.row]["posterURL"].stringValue.isEmpty else {
                cell.tvPosterImageView.image = UIImage(named: "iosLogo")
                cell.tvPosterImageView.contentMode = .scaleAspectFit
                return cell
            }
            cell.tvPosterImageView.image = DisplayHelper.setImageFromURl(url: tvShowData[indexPath.row]["posterURL"].stringValue)
        }
        return cell
    }
    
    //Perform segue when user tap on a collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tvShowSelected = tvShowData[indexPath.row]["id"].intValue
        performSegue(withIdentifier: "tvShowDetailsSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if performSearch {
            return
        }
        if indexPath.item == tvShowData.count - 1 {
            page = page + 1
            if isPopular {
                getTvShows(request: MovieDatabaseRouter.popularMovie(language: "en-US", page: page))
            }
            else if isRecent {
                getTvShows(request: MovieDatabaseRouter.nowPlayingMovie(language: "en-US", page: page))
            }
            else if isTopRated {
                getTvShows(request: MovieDatabaseRouter.topRatedMovie(language: "en-US", page: page))
            }
        }
    }
    
    //MARK: - Actions 
    
    //Selected Popular tab and display all populars TV shows
    @IBAction func popularAction(_ sender: Any) {
        page = 1
        getTvShows(request: MovieDatabaseRouter.popularTvShow(language: "en-US", page: page))
        isPopular = true
        
        popularButton.setTitleColor(UIColor.white, for: .normal)
        recentButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        topRatedButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isRecent {
            animateHiddenView(target: &isRecent, view: recentView)
        }
        else {
            animateHiddenView(target: &isTopRated, view: topRatedView)
        }
        
        animateShowView(view: popularView)
    }
    
    //Selected Recent tab and display all upcommings TV shows
    @IBAction func recentAction(_ sender: Any) {
        page = 1
        getTvShows(request: MovieDatabaseRouter.nowPlayingTvShow(language: "en-US", page: page))
        isRecent = true
        
        recentButton.setTitleColor(UIColor.white, for: .normal)
        popularButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        topRatedButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isPopular {
            animateHiddenView(target: &isPopular, view: popularView)
        }
        else {
            animateHiddenView(target: &isTopRated, view: topRatedView)
        }
        
        animateShowView(view: recentView)
    }
    
    //Selected Top Rated tab and display all top rated TV shows
    @IBAction func topRatedAction(_ sender: Any) {
        page = 1
        getTvShows(request: MovieDatabaseRouter.topRatedTvShow(language: "en-US", page: page))
        isTopRated = true
        
        topRatedButton.setTitleColor(UIColor.white, for: .normal)
        popularButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        recentButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .normal)
        
        if isPopular {
            animateHiddenView(target: &isPopular, view: popularView)
        }
        else {
            animateHiddenView(target: &isRecent, view: recentView)
        }
        
        animateShowView(view: topRatedView)
    }
    
    //Show or hide the search bar
    @IBAction func searchAction(_ sender: Any) {
        if !isSearching {
            showSearchBar()
        }
        else {
            searchTvShow(query: searchBar.text!)
            hideSearchBar()
        }
    }
    
    //MARK: - Functions
    
    /*** HTTP Request ***/
    //Get popular or now playing or top rated movies and push information in the movieData array
    func getTvShows(request: MovieDatabaseRouter) {
        performSearch = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(request).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching upcoming movies on Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            self.tvShowData = []
            for element in  json["results"].arrayValue{
                let obj: JSON = ["id": element["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + element["poster_path"].stringValue]
                self.tvShowData.append(obj)
            }
            self.tvShowCollectionView.reloadData()
            self.tvShowCollectionView.contentOffset = CGPoint.zero
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    //Execute the search
    func searchTvShow(query: String) {
        performSearch = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(MovieDatabaseRouter.searchTvShow(language: "en-US", query: query, page: 1)).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching upcoming movies on Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            self.tvShowData = []
            for element in  json["results"].arrayValue{
                let obj: JSON = ["id": element["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + element["poster_path"].stringValue]
                self.tvShowData.append(obj)
            }
            self.tvShowCollectionView.reloadData()
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
