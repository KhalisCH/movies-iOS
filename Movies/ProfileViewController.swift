//
//  ProfileViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    @IBOutlet weak var myMovieButton: UIButton!
    @IBOutlet weak var myTvShowButton: UIButton!
    @IBOutlet weak var myMovieView: SpringView!
    @IBOutlet weak var myTvShowView: SpringView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isMovie: Bool = true
    var movieData: [JSON] = []                                  //Array of posters url and id of movies
    var tvShowData: [JSON] = []                                 //Array of posters url and id of tv shows
    var movieSelected: Int? = nil                               //Id of the selected movie
    var tvShowSelected: Int? = nil                              //Id of the selected TV show
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Display login page if the user is not connected favorite else
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = UserDefaults.standard
        guard user.bool(forKey: "isConnected") else {
            performSegue(withIdentifier: "connectionSegue", sender: self)
            return
        }
        moviesFavorite()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logOutSegue" {
            let user = UserDefaults.standard
            user.removeObject(forKey: "userID")
            user.removeObject(forKey: "username")
            user.removeObject(forKey: "isConnected")
        }
        else if segue.identifier == "movieDetailsSegue" {
            let controller = segue.destination as! MovieDetailsViewController
            controller.movieId = movieSelected
        }
        else if segue.identifier == "tvShowDetailsSegue" {
            let controller = segue.destination as! TVShowDetailsViewController
            controller.tvShowId = tvShowSelected
        }

    }
    
    //MARK: - CollectionViewDelegate
    
    //Number of elements of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMovie {
            return movieData.count
        }
        else {
            return tvShowData.count
        }
    }
    
    //Number of sections of the collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Treatment on the cells of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell: HybridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hybridCell", for: indexPath) as! HybridCollectionViewCell
        if (isMovie) {
            cell.posterImageView.image = DisplayHelper.setImageFromURl(url: "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row]["url"].stringValue)
        }
        else {
            cell.posterImageView.image = DisplayHelper.setImageFromURl(url: "https://image.tmdb.org/t/p/w500" + tvShowData[indexPath.row]["url"].stringValue)
        }
            return cell
    }
    
    //Perform segue when user tap on a collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMovie {
            movieSelected = movieData[indexPath.row]["videoId"].intValue
            performSegue(withIdentifier: "movieDetailsSegue", sender: self)
        }
        else {
            tvShowSelected = tvShowData[indexPath.row]["videoId"].intValue
            performSegue(withIdentifier: "tvShowDetailsSegue", sender: self)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func myMovieAction(_ sender: Any) {
        isMovie = true
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
        collectionView.reloadData()
    }
    
    @IBAction func myTvShowAction(_ sender: Any) {
        isMovie = false
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
        collectionView.reloadData()
    }
    
    //MARK: - Functions
    
    //Get all favorites
    func moviesFavorite(){
        let user = UserDefaults.standard
        let userID = user.integer(forKey: "userID")
        Alamofire.request(MoviesRouter.getFavorite(userId: userID)).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while get favorite on Details: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            self.movieData = json.arrayValue.filter{ return $0["videoType"].stringValue == "movie" }
            self.tvShowData = json.arrayValue.filter{ return $0["videoType"].stringValue == "tv show" }
            self.collectionView.reloadData()
        }
    }
}
