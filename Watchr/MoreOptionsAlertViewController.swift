//
//  MoreOptionsAlertViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import FirebaseDatabase

class MoreOptionsAlertViewController: UIAlertController {
    
    var showId : Int?
    weak var delegate: CellActionsProtocol?
    var customHeader: MoreOptionsHeader?
    
    var watchrStatusDelegate: WatchrStatusProtocol = WatchrStatusDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "\n\n\n\n\n\n"
        self.message = nil
        
        configureView()
        colorViews()
        addAppropriateActions()
        loadShowDetails(showId: showId!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func configureView(){
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: self.view.bounds.size.width - margin * 4.0, height: 120)
        customHeader = MoreOptionsHeader.instanceFromNib()
        customHeader?.frame = rect
        customHeader?.backgroundColor = mediumTheme
        customHeader?.backgroundView.layer.cornerRadius = 2
        self.view.addSubview(customHeader!)
        
        let gotToShowDetails = UIAlertAction(title: "Go to Show Details", style: .default, handler: {(alert: UIAlertAction!) in self.goToShowDetailsClicked()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        cancelAction.setValue(mediumTheme, forKey: "titleTextColor")
        
        self.addAction(gotToShowDetails)
        self.addAction(cancelAction)
    }
    
    func colorViews(){
        let subview = self.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        for view in alertContentView.subviews{
            view.backgroundColor = darkTheme
        }
        self.view.tintColor = whiteTheme
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        alertContentView.layer.cornerRadius = 15
    }
    
    func addAppropriateActions(){
        
        if(!(currentUser?.watched.contains(self.showId!))!){
            let addToWatched = UIAlertAction(title: "Watched", style: .default, handler: {(alert: UIAlertAction!) in self.watchrStatusDelegate.addShowToWatched(showId: self.showId!)})
            
            addToWatched.setValue(UIImage(named: "heart"), forKey: "image")
            self.addAction(addToWatched)
        }
        
        if(!(currentUser?.watching.contains(self.showId!))!){
            let addToWatchingNowAction = UIAlertAction(title: "Watching Now", style: .default, handler: {(alert: UIAlertAction!) in self.watchrStatusDelegate.addShowToWatchingNow(showId: self.showId!)})
            
            //addToWatchingNowAction.setValue(UIImage(named: "eye"), forKey: "image")
            self.addAction(addToWatchingNowAction)
        }
        
        if(!(currentUser?.watchList.contains(self.showId!))!){
            let addToWatchListAction = UIAlertAction(title: "Add to Watch List", style: .default, handler: {(alert: UIAlertAction!) in self.watchrStatusDelegate.addShowToWatchList(showId: self.showId!)})
            
            //addToWatchListAction.setValue(UIImage(named: "list"), forKey: "image")
            self.addAction(addToWatchListAction)
        }
        
        let shouldAddUnwatched = (currentUser?.watchList.contains(self.showId!))! || (currentUser?.watched.contains(self.showId!))! || (currentUser?.watching.contains(self.showId!))!
        
        if (shouldAddUnwatched){
            let unwatchedAction = UIAlertAction(title: "Unwatched", style: .default, handler: {(alert: UIAlertAction!) in self.watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: self.showId!)})
            self.addAction(unwatchedAction)
        }
    }
    
    func goToShowDetailsClicked(){
        if((self.delegate?.responds(to: Selector(("goToShowDetailsFromOptions:")))) != nil)
        {
            self.delegate?.goToShowDetailsFromOptions(showId: self.showId!)
        }
    }
    
    func loadShowDetails(showId: Int){
        TVDetailedMDB.tv(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            if let show = apiReturn.1{
                self.customHeader?.showName.text = show.name
                getShowStatus(show: show)
                self.customHeader?.showStatus.text = stringForShowStatus(show: show)
                if let path = show.poster_path{
                    let url = URL(string: "https://image.tmdb.org/t/p/w185//" + path)
                    self.customHeader?.showImage.sd_setImage(with: url)
                }
                // set image status
                //self.customHeader?.showStatusImage.image = UIImage(named: <#T##String#>)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
