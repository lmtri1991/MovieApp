//
//  MovieCell.swift
//  MovieApp
//
//  Created by Hung Nguyen on 11/12/15.
//  Copyright © 2015 Hung Nguyen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var descMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
