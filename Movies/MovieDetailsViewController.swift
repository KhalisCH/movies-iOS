//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieDetailsViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!     //ImageView which is backdrop poster of the movie
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var genreLabel: PaddingLabel!        //Label for the genre
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var isFavorite: Bool = false                        //To know if this movie is a favorite or not
    var movieId: Int? = nil                             //Id of the movie
    var youtubeId: String = ""                          //Id of the trailer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrailer(id: movieId!)
        getDetails(id: movieId!)
        
        let color = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        DisplayHelper.genreLabel(label: genreLabel, color: color)
    }
    
    //MARK: - Actions
    
    //Dismiss the view
    @IBAction func goBackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Show an empty or a plain heart to show if this movie is a favorite
    @IBAction func favoriteAction(_ sender: Any) {
        if isFavorite {
            isFavorite = false
            navigationBar.rightBarButtonItem?.image = UIImage(named: "ic_empty_favorite_24pt")
            navigationBar.rightBarButtonItem?.tintColor = UIColor.white
        }
        else {
            isFavorite = true
            navigationBar.rightBarButtonItem?.image = UIImage(named: "ic_plain_favorite_24pt")
            navigationBar.rightBarButtonItem?.tintColor = UIColor(red: 212/255, green: 67/255, blue: 74/255, alpha: 1.0)
        }
    }

    //When user tap on the play button, launch youtube with the video
    @IBAction func playAction(_ sender: Any) {
        if youtubeId.isEmpty {
            return
        }
        var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            UIApplication.shared.open(youtubeUrl as URL, options: [:], completionHandler: .none)
        } else{
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.open(youtubeUrl as URL, options: [:], completionHandler: .none)
        }
    }
    
    //MARK: - Functions
    
    //Get the details of a specific movie
    func getDetails(id: Int) {
        Alamofire.request(MovieDatabaseRouter.movieDetails(id: id, language: "en-US")).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching movie details on Details: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            self.updateDetails(details: json)
        }
    }
    
    //Get the trailer of a specific movie
    func getTrailer(id: Int) {
        Alamofire.request(MovieDatabaseRouter.movieTrailer(id: id, language: "en-US")).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching movie details on Details: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            let trailer = json["results"].arrayValue.filter( { return $0["name"] == "Official Trailer" } )
            if !trailer.isEmpty {
                self.youtubeId = trailer[0]["key"].stringValue
            }
        }
    }
    
    //Update the information
    func updateDetails(details: JSON) {
        if self.youtubeId.isEmpty {
            playButton.isHidden = true
        }
        if details["backdrop_path"].stringValue.isEmpty {
            videoImageView.image = UIImage(named: "iosLogo")
        }
        else {
            videoImageView.image = DisplayHelper.setImageFromURl(url: "https://image.tmdb.org/t/p/w500" + details["backdrop_path"].stringValue)
        }
        titleLabel.text = details["original_title"].stringValue
        voteAverageLabel.text = String(format: "%.1f", details["vote_average"].floatValue)
        popularityLabel.text = String(format: "%.1f", details["popularity"].floatValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: details["release_date"].stringValue)
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: date!)
        
        var genreArray: [String] = []
        for (_,subJson):(String, JSON) in details["genres"] {
            genreArray.append(subJson["name"].stringValue)
        }
        genreLabel.text = genreArray.joined(separator: " - ")
        
        overviewTextView.text = details["overview"].stringValue
    }
}

//A subclass of UILabel to add custom padding
class PaddingLabel: UILabel {
    
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: leftInset, bottom: 5, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
