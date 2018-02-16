//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 13/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableCellImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if let meme = meme {
            tableCellImageView.image = meme.memedImage
            topLabel.text = meme.topText
            bottomLabel.text = meme.bottomText
        }
    }
}
