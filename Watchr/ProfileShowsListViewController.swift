//
//  ProfileShowsListViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/16/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import PageMenu
import AMScrollingNavbar

class ProfileShowsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MoreOptionsProtocol {
    
    @IBOutlet var showsTableView: UITableView!
    
    var showsToDisplay: [TVDetailedMDB] = []
    var showStatus: WatchrShowStatus?
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsTableView.delegate = self
        showsTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusListChanged), name: NSNotification.Name(rawValue: showStatusListsChanged), object: nil)
        
        loadShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*  Uncomment to user scrolling nav bar
         if let navigationController = self.navigationController as? ScrollingNavigationController {
         navigationController.followScrollView(showsTableView, delay: 75.0, scrollSpeedFactor: 2, followers: [((self.parent?.parent as! ProfileMainViewController).profileDetailsView)!, (self.parent as! CAPSPageMenu).view])
         }
         */
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let profileView = (self.parent?.parent as! ProfileMainViewController).profileDetailsView
        let scrollMenuView = (self.parent as! CAPSPageMenu).view
        let offsetY = scrollView.contentOffset.y

        if (offsetY > 0) {
            //profileView?.frame.origin.y = (profileView?.frame.origin.y)! - 1
            
            /*
            if((scrollMenuView?.frame.origin.y)! > CGFloat(0)){
                scrollMenuView?.frame.origin.y = (scrollMenuView?.frame.origin.y)! - 1
                scrollMenuView?.frame = CGRect(x: (scrollMenuView?.frame.origin.x)!, y: (scrollMenuView?.frame.origin.y)!, width: (scrollMenuView?.frame.width)!, height: (scrollMenuView?.frame.height)! + 1)
            */
                print(scrollMenuView?.frame.origin.y)
            
        }
    }
    
    func statusListChanged(){
        showsToDisplay.removeAll()
        loadShows()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0){
            return cellSpacingHeight
        }
        return cellSpacingHeight / 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (section == showsToDisplay.count - 1){
            return cellSpacingHeight
        }
        return cellSpacingHeight / 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showsTableView.dequeueReusableCell(withIdentifier: "ShowProfileTableViewCell", for: indexPath) as! ShowProfileTableViewCell
        let show = showsToDisplay[indexPath.section]
        
        cell.showId = show.id
        cell.showNameLabel.text = show.name
        if let path = show.poster_path{
            let url = URL(string: "https://image.tmdb.org/t/p/w185//" + path)
            cell.showImage.sd_setImage(with: url)
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = showsToDisplay[indexPath.section]
        performSegue(withIdentifier: "toShowDetailFromProfile", sender: show)
    }
    
    func loadShows(){
        
        // TODO Don't load until user is initialized
        if let user = currentUser{
            switch showStatus! {
            case .Watched:
                getAllShowForCategory(listOfShowsToGet: user.watched)
            case .Watching:
                getAllShowForCategory(listOfShowsToGet: user.watching)
            case .WatchList:
                getAllShowForCategory(listOfShowsToGet: user.watchList)
            case .NotWatched:
                break
            }
        }
    }
    
    func getAllShowForCategory(listOfShowsToGet: [Int]){
        
        for showId in listOfShowsToGet{
            getShowDetails(showId: showId)
        }
    }
    
    func getShowDetails(showId: Int){
        
        TVDetailedMDB.tv(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            if let show = apiReturn.1{
                self.showsToDisplay.append(show)
                self.showsTableView.reloadData()
            }
        }
    }
    
    func loadMoreOptions(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
            
        }
    }
    
    func goToShowDetailsFromOptions(showId: Int){
        
        TVMDB.tv(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            if let show = apiReturn.1{
                self.performSegue(withIdentifier: "toShowDetailFromProfile", sender: show)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
