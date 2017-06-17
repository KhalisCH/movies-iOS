//
//  DisplayHelper.swift
//  Movies
//
//  Created by Khalis on 17/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit

class DisplayHelper {
    
    //Create and setting gradient layer
    class func createGradientLayer(width: CGFloat, height: CGFloat) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer! = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        let firstColor = UIColor.init(hex: "#6684a3")
        let secondColor = UIColor.init(hex: "#325b84")
        let thirdColor = UIColor.init(hex: "#003366")
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.locations = [0.0, 0.3, 0.75]
        return gradientLayer
    }
    
    //Set an image from URL
    class func setImageFromURl(url: String) -> UIImage {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        return UIImage()
    }
}
