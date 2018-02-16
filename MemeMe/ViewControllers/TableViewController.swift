//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 09/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: Properties
    
    let numberOfSections = 1
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! TableViewCell
        
        cell.meme = memes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.memedImage = memes[indexPath.row].memedImage
      
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
