//
//  MoviesDetailViewController.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-10.
//  Copyright © 2019 Rose H. All rights reserved.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var starImage: UIImageView?
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var review: UITextField!
    @IBOutlet weak var reviewButton: UIButton!
    
    private var movie: Movie?
    private var poster: UIImage?
    private var movieTitle: String?
    private var movieoverView: String?
    private var reviewTitleText: String?
    private var reviewText: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        _ = self.view
        self.navigationItem.title = self.title
        self.title = self.movieTitle
        self.moviePoster.image = self.poster
        self.movieDescription.text = self.movieoverView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addReviewButtonPressed(_ sender: Any) {
        if reviewButton.currentTitle == "Add" {
            self.reviewTitleText = self.reviewTitle.text
            self.reviewTitle.backgroundColor = UIColor.clear
            self.reviewTitle.textColor = UIColor.white
            self.reviewTitle.isUserInteractionEnabled = false
            
            self.reviewText = self.review.text
            self.review.backgroundColor = UIColor.clear
            self.review.textColor = UIColor.white
            self.review.isUserInteractionEnabled = false
            
            self.reviewButton.setTitle("Edit", for: .normal)
        } else {
            self.reviewTitle.backgroundColor = UIColor.white
            self.reviewTitle.textColor = UIColor.darkText
            self.reviewTitle.isUserInteractionEnabled = true
            
            self.review.backgroundColor = UIColor.white
            self.review.textColor = UIColor.darkText
            self.review.isUserInteractionEnabled = true
            
            self.reviewButton.setTitle("Add", for: .normal)
        }
    }
    
    
    func setIBOutlests(movie: Movie){
        self.movie = movie
        self.movieTitle = movie.title
        self.movieoverView = movie.overView
        self.poster = movie.poster
        self.setRating(for: movie)
    }
    
    func setRating(for movie: Movie){
        switch movie.fiveStarRating {
        case 1:
            let image = UIImage(named: "OneStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        case 2:
            let image = UIImage(named: "TwoStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        case 3:
            let image = UIImage(named: "ThreeStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        case 4:
            let image = UIImage(named: "FourStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        case 5:
            let image = UIImage(named: "FiveStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        default:
            let image = UIImage(named: "OneStars")?.withRenderingMode(.alwaysTemplate)
            self.starImage?.image = image
        }
        
    }
}

