//
//  SearchViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var clearSearch: UIButton!
    @IBOutlet var searchTableView: UITableView!
    
    var showsFound: [TVMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        self.title = "Search"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchTableView.isHidden = showsFound.count == 0 ? true : false
        return showsFound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        cell.showLabel.text = showsFound[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = showsFound[indexPath.row]
        performSegue(withIdentifier: "SearchToShowDetail", sender: show)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (!textField.text!.isEmpty){
            SearchMDB.tv(apiKey, query: textField.text!, page: 1, language: "en", first_air_date_year: nil){
                data, tvShows in
                if(tvShows != nil){
                    self.showsFound = tvShows!
                    self.searchTableView.reloadData()
                }
                else{
                    self.clearSearchEntries()
                }
            }
        }
        return true
    }
    
    func clearSearchEntries(){
        self.showsFound.removeAll()
        self.searchTableView.reloadData()
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        searchBar.text = ""
        clearSearchEntries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
        }
    }
    
}
