//
//  PreviewShowDetailViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/22/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class PreviewShowDetailViewController: UIViewController {
    
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showDescription: UITextView!
    @IBOutlet var showLabel: UILabel!
    
    var show: TVMDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView(){
        showLabel.text = show?.name!
        showDescription.text = show?.overview!
        //showDescription.updateTextFont()
        
        if let path = show?.backdrop_path{
            let url = URL(string:"https://image.tmdb.org/t/p/w500_and_h281_bestv2/" + path)
            self.showImage.sd_setShowActivityIndicatorView(true)
            self.showImage.sd_setIndicatorStyle(.whiteLarge)
            self.showImage.sd_setImage(with: url)
        }
        print(show?.overview!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
