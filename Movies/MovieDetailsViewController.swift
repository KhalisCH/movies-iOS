//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var videoImageView: UIImageView!     //ImageView which is backdrop poster of the movie
    
    @IBOutlet weak var genreLabel: PaddingLabel!        //Label for the genre
    @IBOutlet weak var genreLabel2: PaddingLabel!       //Label for the genre
    @IBOutlet weak var genreLabel3: PaddingLabel!       //Label for the genre
    
    var isFavorite: Bool = false                        //To know if this movie is a favorite or not

    override func viewDidLoad() {
        super.viewDidLoad()
        videoImageView.image = DisplayHelper.setImageFromURl(url: "https://image.tmdb.org/t/p/w500/22eFfWlar6MtXO5qG25TkjLphoj.jpg")
        
        let color = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        DisplayHelper.genreLabel(label: genreLabel, color: color)
        
        let color2 = UIColor(red: 76/255, green: 84/255, blue: 104/255, alpha: 1.0)
        DisplayHelper.genreLabel(label: genreLabel2, color: color2)
        
        let color3 = UIColor(red: 51/255, green: 56/255, blue: 118/255, alpha: 1.0)
        DisplayHelper.genreLabel(label: genreLabel3, color: color3)
    }
    
    //MARK: - Actions
    
    //Dismiss the view
    @IBAction func goBackToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Show an empty or a plain heart to show if this movie is a favorite
    @IBAction func favoriteAction(_ sender: Any) {
        if isFavorite {
            isFavorite = false
            navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_empty_favorite_24pt")
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
        else {
            isFavorite = true
            navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_plain_favorite_24pt")
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 212/255, green: 67/255, blue: 74/255, alpha: 1.0)
        }
    }
    
    //When user tap on the play button, launch youtube with the video
    @IBAction func playAction(_ sender: Any) {
        let youtubeId = "jIM4-HLtUM0"
        var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            UIApplication.shared.open(youtubeUrl as URL, options: [:], completionHandler: .none)
        } else{
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.open(youtubeUrl as URL, options: [:], completionHandler: .none)
        }
    }
}

//A subclass of UILabel to add custom padding
class PaddingLabel: UILabel {
    
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 2, left: leftInset, bottom: 2, right: rightInset)
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
