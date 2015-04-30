//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Chris Cruz on 4/14/15.
//  Copyright (c) 2015 Chris Cruz. All rights reserved.
//

import UIKit

class MovieDetailViewController : UIViewController {
    var movie : Movie!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieSynopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        posterImage.setImageWithURL(movie?.imageUrl)
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = movie.mpaaRating
        movieSynopsisLabel.text = movie?.synopsis
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

