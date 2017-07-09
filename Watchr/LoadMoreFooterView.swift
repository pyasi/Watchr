//
//  CollectionReusableView.swift
//  Watchr
//
//  Created by Peter Yasi on 7/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class LoadMoreFooterView: UICollectionReusableView {
        
    @IBOutlet var loadMoreButton: UIButton!
 
    func layoutView(){
                
        self.loadMoreButton.layer.shadowColor = UIColor.black.cgColor
        self.loadMoreButton.layer.shadowOpacity = 0.75
        self.loadMoreButton.layer.shadowRadius = 3
        self.loadMoreButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.loadMoreButton.layer.shouldRasterize = true
        self.loadMoreButton.layer.masksToBounds = false
    }
}
