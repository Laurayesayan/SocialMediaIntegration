//
//  ViewController.swift
//  SocialMediaIntegration_2_9
//
//  Created by Лаура Есаян on 23.03.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookShare
import FBSDKShareKit


class ViewController: UIViewController, SharingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .success(granted: _, declined: _, token: _):
            alertController = UIAlertController(title: "Login Success", message: "Login succeeded", preferredStyle: .alert)
            
        case .failed(let error):
            alertController = UIAlertController(title: "Login Fail", message: "Login failed with error \(error)", preferredStyle: .alert)
        default:
            alertController = UIAlertController(title: "Login Cancelled", message: "User cancelled login.", preferredStyle: .alert)
        }
        
        self.present(alertController, animated: true) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loginToFacebook(_ sender: Any) {
        if AccessToken.current == nil {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [.publicProfile, .userFriends], viewController: self) { result in
                self.loginManagerDidComplete(result)
            }
        } else {
            let alertController = UIAlertController(title: "Login", message: "Already logged in", preferredStyle: .alert)
            present(alertController, animated: true) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logoutFromFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let alertController = UIAlertController(title: "Logout", message: "Logged out.", preferredStyle: .alert)
        present(alertController, animated: true) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func shareLink(url: String) {
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: url)!
        shareContent.quote = "Test share from my app"
        ShareDialog.init(fromViewController: self, content: shareContent, delegate: self).show()
        
    }

    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
    
    @IBAction func facebookShare(_ sender: Any) {
        shareLink(url: "https://github.com/facebookarchive/facebook-swift-sdk/blob/master/Samples/Catalog/Sources/ShareDialogViewController.swift")
    }
    

}


