//
//  MenuTableViewController.swift
//  Movies
//
//  Created by Khalis on 16/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON

class MenuTableViewController: UITableViewController {
    
    //MARK: - Properties
    var genresArray: [JSON] = []
    var segue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(segue)
        tableView.dataSource = self
        SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
    }

    // MARK: - TableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.genreLabel.text = genresArray[indexPath.row].stringValue
        return cell
    }
    
    //MARK: - Functions
    
    //Get genres and push information in the genresArray variable
    func getMovies(request: MovieDatabaseRouter) {
        Alamofire.request(request).responseJSON{ response in
            guard response.result.isSuccess else {
                print("Error while fetching genres on Menu: \(response.result.error)")
                return
            }
            let json = JSON(response.result.value!)
            print(json)
//            self.genresArray = []
//            for i in 0..<20 {
//                let obj: JSON = ["id": json["results"][i]["id"].intValue, "name": "https://image.tmdb.org/t/p/w500" + json["results"][i]["poster_path"].stringValue]
//                self.genresArray.append(obj)
//            }
//            self.tableView.reloadData()
        }
    }
}
