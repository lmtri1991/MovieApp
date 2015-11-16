//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Tran Ngoc Hai Dang on 11/15/15.
//  Copyright © 2015 Tran Ngoc Hai Dang. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [NSDictionary]()
    let dataURL = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214"
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        getData()
    }
    
    func checkConnectNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getData(){
        let connection = checkConnectNetwork()

        if(!connection){
            let alert = UIAlertView()
            alert.title = "Connection"
            alert.message = "No connection"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        let url = NSURL(string: dataURL)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        CozyLoadingActivity.show("Loading...", disableUI: true)
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                CozyLoadingActivity.hide(success: false, animated: true)
                print("error loading from URL", error!)
                return
            }
            CozyLoadingActivity.hide(success: true, animated: true)
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            self.movies = json["movies"] as! [NSDictionary]
            //            print("movies", self.movies)
            
            if self.refreshControl.refreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        task.resume()
    }
    
    func onRefresh(){
        getData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let item = movies[indexPath.row]
        cell.titleMovie.text = item["title"] as! String?
        cell.descMovie.text = item["synopsis"] as! String?

        let poster = item["posters"] as! NSDictionary
        let image = poster["thumbnail"] as! String
        let url = NSURL(string: image)
        cell.imageMovie.setImageWithURL(url!)

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "MovieDetaiViewController") {
            if let destinationVC = segue.destinationViewController as? MovieDetaiViewController{
                let cell = sender as! UITableViewCell
                let indexPath = self.tableView.indexPathForCell(cell)
                let item = movies[indexPath!.row]
                destinationVC.movies = item
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
