//
//  MovieDetaiViewController.swift
//  MovieApp
//
//  Created by Tran Ngoc Hai Dang on 11/15/15.
//  Copyright © 2015 Tran Ngoc Hai Dang. All rights reserved.
//

import UIKit

class MovieDetaiViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    var movies: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let poster = movies["posters"] as! NSDictionary
        let image = poster["thumbnail"] as! String
        let url = NSURL(string: image)
        background.setImageWithURL(url!)
        
        movieName.text = movies["title"] as! String
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
