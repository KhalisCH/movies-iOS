//
//  MenuTableViewController.swift
//  Movies
//
//  Created by Khalis on 16/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import UIKit
import SideMenu

class MenuTableViewController: UITableViewController {
    
    //MARK: - Properties
    var genresArray: [String] = ["Action", "Aventure", "Drama", "Science-Fiction", "Suspense", "Thriller", "Western"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.genreLabel.text = genresArray[indexPath.row]
        return cell
    }
}
