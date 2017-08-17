//
//  ShowProfileTableViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 8/16/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class ShowProfileTableViewCell: UITableViewCell {

    @IBOutlet var showImage: UIImageView!
    @IBOutlet var moreOptionsButton: UIButton!
    @IBOutlet var showNameLabel: UILabel!
    
    var showId: Int?
    var delegate: MoreOptionsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showImage.layer.masksToBounds = false
        showImage.layer.cornerRadius =  2
        showImage.clipsToBounds = true
        showImage.layer.borderWidth = 1.0
        showImage.layer.borderColor = darkTheme.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionsMenuButtonTapped(_ sender: Any) {
        let alertController = MoreOptionsAlertViewController()
        alertController.showId = self.showId!
        alertController.delegate = self.delegate
        
        DispatchQueue.main.async {
            if((self.delegate?.responds(to: Selector(("loadMoreOptions:")))) != nil)
            {
                self.delegate?.loadMoreOptions(controller: alertController)
            }
        }
    }
    
    func goToShowDetailsClicked(){
        if((self.delegate?.responds(to: Selector(("goToShowDetailsFromOptions:")))) != nil)
        {
            self.delegate?.goToShowDetailsFromOptions(showId: self.showId!)
        }
    }

}
