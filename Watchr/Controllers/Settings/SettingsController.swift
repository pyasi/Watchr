//
//  SettingsController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/13/18.
//  Copyright © 2018 Peter Yasi. All rights reserved.
//


import UIKit
import Firebase
import FBSDKLoginKit

class SettingsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section, " ", indexPath.row)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/grade-master-grade-tracker/id1180853297?mt=8")! as URL)
                break
            case 1:
                let textToShare = "Check out this Grade Tracking/Calculator app!"
                
                if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/grade-master-grade-tracker/id1180853297?mt=8") {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                }
                break
            default:break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let email = "grademasterapp@gmail.com"
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.shared.openURL(url as! URL)
            default:break
            }
        case 2:
            switch indexPath.row {
            case 0:
                logOut()
                break
                
            default:break
                
            }
        // other sections (and _their_ rows)
        default : break
        }
    }
    func logOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

