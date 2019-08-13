//
//  TableViewCell.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-10.
//  Copyright © 2019 Rose H. All rights reserved.
//

import UIKit

class MovieCustomCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    var starColor = false
    
    func setUp(with movie: Movie) {
        self.moviePoster.image = movie.poster
        self.movieTitle.text = movie.title
        self.movieDescription.text = movie.overView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
