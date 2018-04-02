//
//  MoreOptionsHeader.swift
//  Watchr
//
//  Created by Peter Yasi on 8/21/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class MoreOptionsHeader: UIView {

    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showName: UILabel!
    @IBOutlet var showStatus: UILabel!
    @IBOutlet var showStatusImage: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    class func instanceFromNib() -> MoreOptionsHeader {
        return UINib(nibName: "MoreOptionsHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MoreOptionsHeader
    }
    
    
}
