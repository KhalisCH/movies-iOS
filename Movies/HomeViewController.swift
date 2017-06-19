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
    
    @IBOutlet weak var gradientView: UIView!                    //View for the gradient
    @IBOutlet weak var movieCollectionView: UICollectionView!   //CollectionView for the movies
    @IBOutlet weak var tvCollectionView: UICollectionView!      //CollectionView for the tv shows
    
    var movieData: [JSON] = []                                  //Array of posters url and id of movies
    var tvShowData: [JSON] = []                                 //Array of posters url and id of tv shows
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                cell.homeMoviePosterImageView.image = DisplayHelper.setImageFromURl(url: movieData[indexPath.row]["posterURL"].stringValue)
            }
            return cell
        }
        else {
            let cell: TVCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! TVCollectionViewCell
            if !tvShowData.isEmpty {
                cell.tvPosterImageView.image = DisplayHelper.setImageFromURl(url: tvShowData[indexPath.row]["posterURL"].stringValue)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === movieCollectionView {
            performSegue(withIdentifier: "movieDetailsSegue", sender: self)
        }
    }
    
    //MARK: - Actions
    
    //Unwind segue from AccountViewController
    @IBAction func unwindFromAccount(segue:UIStoryboardSegue) {
        
    }
    
    //MARK: - Functions
    
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
        }
    }
    
    func getNowPlayingTvShow() {
        Alamofire.request(MovieDatabaseRouter.nowPlayingTvShow(language: "en-US", page: 1)).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching now playing tv show son Home: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            print(json)
            for i in 0..<10 {
                let obj: JSON = ["id": json["results"][i]["id"].intValue, "posterURL": "https://image.tmdb.org/t/p/w500" + json["results"][i]["poster_path"].stringValue]
                self.tvShowData.append(obj)
            }
            self.tvCollectionView.reloadData()
        }
    }
}
