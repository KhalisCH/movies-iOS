//
//  ProfileViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Spring

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    @IBOutlet weak var myMovieButton: UIButton!
    @IBOutlet weak var myTvShowButton: UIButton!
    @IBOutlet weak var myMovieView: SpringView!
    @IBOutlet weak var myTvShowView: SpringView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isConnected: Bool = true
    var isMovie: Bool = true
    var moviePosters: [String] = ["https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg", "https://image.tmdb.org/t/p/w500/zxkY8byBnCsXodEYpK8tmwEGXBI.jpg"]
    var tvShowPosters: [String] = ["https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg", "https://image.tmdb.org/t/p/w500/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Display login page if the user is not connected favorite else
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isConnected {
            performSegue(withIdentifier: "connectionSegue", sender: self)
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
            let cell: HybridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hybridCell", for: indexPath) as! HybridCollectionViewCell
        if (isMovie) {
            cell.posterImageView.image = DisplayHelper.setImageFromURl(url: moviePosters[indexPath.row])
        }
        else {
            cell.posterImageView.image = DisplayHelper.setImageFromURl(url: tvShowPosters[indexPath.row])
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}
