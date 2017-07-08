//
//  ShowDetailViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stillsImageView: UIImageView!
    @IBOutlet var showInfoView: UIView!
    @IBOutlet var segmentControl: SWSegmentedControl!
    
    var show: TVMDB?
    var stills: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.title = show?.name
        fillBannerImage()
        getStillsForShow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillBannerImage(){
        if let backdrop = show!.backdrop_path{
            let url = URL(string:"https://image.tmdb.org/t/p/w185//" + backdrop)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.stillsImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @IBAction func showStillsTapped(_ sender: Any) {
        fillStillsImageView(newStills: stills)
    }
    func fillStillsImageView(newStills: [UIImage]){
        stillsImageView.animationImages = newStills
        stillsImageView.animationDuration = Double(stills.count * 3)
        stillsImageView.startAnimating()
        
    }
    
    func getStillsForShow(){
        
        print(show!.id!)
        TVEpisodesMDB.images(apiKey, tvShowId: show!.id!, seasonNumber: 1, episodeNumber: 1){
            apiReturn, images in
            if let images = images{
                for still in images.stills{
                    
                    let url = URL(string:"https://image.tmdb.org/t/p/w185//" + still.file_path!)
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            self.stills.append(UIImage(data: data!)!)
                            print(self.stills.count)
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            showInfoView.isHidden = false
            //locationContainerView.isHidden = true
        case 1:
            showInfoView.isHidden = true
            //locationContainerView.isHidden = false
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationVC = segue.destination  as? ShowInformationViewController{
                destinationVC.show = show
            }
        }
}
