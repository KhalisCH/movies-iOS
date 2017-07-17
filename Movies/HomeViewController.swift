//
//  HomeViewController.swift
//  Movies
//
//  Created by Khalis on 15/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!                    //View for the gradient
    @IBOutlet weak var movieCollectionView: UICollectionView!   //CollectionView for the movies
    @IBOutlet weak var tvCollectionView: UICollectionView!      //CollectionView for the tv shows
    
    var movieData: [JSON] = []                                  //Array of posters url and id of movies
    var tvShowData: [JSON] = []                                 //Array of posters url and id of tv shows
    var movieSelected: Int? = nil                               //Id of the selected movie
    var tvShowSelected: Int? = nil                              //Id of the selected TV show
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        getUpcomingMovies()
        getNowPlayingTvShow()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
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
        else {
            let controller = segue.destination as! TVShowDetailsViewController
            controller.tvShowId = tvShowSelected
        }
    }
    
    //MARK: - CollectionViewDelegate
    
    //Number of elements of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //Number of sections of the collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Treatment on the cells of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === movieCollectionView {
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
            if !movieData.isEmpty {
                guard movieData[indexPath.row]["posterURL"].stringValue != "https://image.tmdb.org/t/p/w500" else {
                    cell.homeMoviePosterImageView.image = UIImage(named: "iosLogo")
                    cell.homeMoviePosterImageView.contentMode = .scaleAspectFit
                    return cell
                }
                cell.homeMoviePosterImageView.image = DisplayHelper.setImageFromURl(url: movieData[indexPath.row]["posterURL"].stringValue)
            }
            return cell
        }
        else {
            let cell: TVCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! TVCollectionViewCell
            if !tvShowData.isEmpty {
                guard tvShowData[indexPath.row]["posterURL"].stringValue != "https://image.tmdb.org/t/p/w500" else {
                    cell.tvPosterImageView.image = UIImage(named: "iosLogo")
                    cell.tvPosterImageView.contentMode = .scaleAspectFit
                    return cell
                }
                cell.tvPosterImageView.image = DisplayHelper.setImageFromURl(url: tvShowData[indexPath.row]["posterURL"].stringValue)
            }
            return cell
        }
    }
    
    //Perform segue when user tap on a collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === movieCollectionView {
            movieSelected = movieData[indexPath.row]["id"].intValue
            performSegue(withIdentifier: "movieDetailsSegue", sender: self)
        }
        else {
            tvShowSelected = tvShowData[indexPath.row]["id"].intValue
            performSegue(withIdentifier: "tvShowDetailsSegue", sender: self)
        }
    }
    
    //MARK: - Actions
    
    //Unwind segue from AccountViewController
    @IBAction func unwindFromAccount(segue:UIStoryboardSegue) {
        
    }
    
    //MARK: - Functions
    
    //Get upcoming movies and push information in the movieData array
    func getUpcomingMovies() {
        Alamofire.request(MovieDatabaseRouter.upcomingMovie(language: "en-US", page: 1, region: "US")).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching upcoming movies on Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            for i in 0..<10 {
                let obj: JSON = ["id": json["results"][i]["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + json["results"][i]["poster_path"].stringValue]
                self.movieData.append(obj)
            }
            self.movieCollectionView.reloadData()
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    //Get now playing TV shows and push information in the tvShowData array
    func getNowPlayingTvShow() {
        Alamofire.request(MovieDatabaseRouter.nowPlayingTvShow(language: "en-US", page: 1)).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching now playing tv show son Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            for i in 0..<10 {
                let obj: JSON = ["id": json["results"][i]["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + json["results"][i]["poster_path"].stringValue]
                self.tvShowData.append(obj)
            }
            self.tvCollectionView.reloadData()
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
}
