//
//  ShowRecommendationViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 8/10/18.
//  Copyright © 2018 Peter Yasi. All rights reserved.
//

//
//  ShowCollectionCellCollectionViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowRecommendationViewCell: UICollectionViewCell {
    
    @IBOutlet var imageEmptyState: UIImageView!
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    
    var showId: Int?
}

