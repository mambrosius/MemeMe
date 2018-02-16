//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 13/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Properties
    
    var memedImage: UIImage?
    
    // Setting the color of the status bar items to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = memedImage
    }
}
