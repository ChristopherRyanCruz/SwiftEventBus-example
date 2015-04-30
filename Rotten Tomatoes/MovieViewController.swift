//
//  MovieViewController.swift
//  Rotten Tomatoes
//
//  Created by Chris Cruz on 4/14/15.
//  Copyright (c) 2015 Chris Cruz. All rights reserved.
//

import Foundation
import UIKit

class MovieViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var movies : NSMutableArray = []
    var refreshControl:UIRefreshControl!
    let apiURL = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=US")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeRefreshControl()
        fetchMovieData()
        SwiftEventBus.onBackgroundThread(self, name: "getReadyToUpdateUI", handler: { result in
            SwiftEventBus.post("updateUI")
        })

        SwiftEventBus.onMainThread(self, name: "updateUI", handler: { result in
            self.presentViewController(UIViewController(), animated: true, completion: nil)
            })
    }
    
    func refresh() {
        refreshControl.endRefreshing()
        fetchMovieData()
    }
    
    func initializeRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func fetchMovieData() {
        let request = NSURLRequest(URL: apiURL)
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if self.view == nil {
                return
            }
            
            if error != nil {
                //there is a Network error.
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                let networkingErrorNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                networkingErrorNotification.mode = MBProgressHUDMode.Text
                networkingErrorNotification.labelText = "Network Error"
                networkingErrorNotification.hide(true, afterDelay: 2)
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    self.parseData(json["movies"] as! NSArray)
                    SwiftEventBus.post("getReadyToUpdateUI")
                }
            }
            
        }
    }
    
    func parseData(dataArray: NSArray) {
        for item in dataArray {
            self.movies.addObject(Movie(dictionary: item as! NSDictionary))
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = self.movies[indexPath.row] as! Movie
        cell.titleLabel.text = movie.title
        cell.summaryLabel.text = movie.synopsis
        
        var url = movie.imageUrl
        cell.posterImageView.setImageWithURL(url)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as! MovieDetailViewController
        var rowSelected = tableView.indexPathForSelectedRow()?.row
        var movie = self.movies[rowSelected!] as! Movie
        detailViewController.movie =  movie
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

