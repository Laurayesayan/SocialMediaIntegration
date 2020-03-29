//
//  GoogleViewController.swift
//  SocialMediaIntegration_2_9
//
//  Created by Лаура Есаян on 27.03.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "676507984305-78r8vok60pr06ao8kvo3hmam470s8kec.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    
    @IBAction func signIn(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBAction func signOutFromGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        self.userImageView.image = nil
        self.userNameLabel.text = ""
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        if let user = user {
            let imageURL = user.profile.imageURL(withDimension: 200)?.absoluteString
            self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
            self.userImageView.setImage(url: imageURL!)
            self.userNameLabel.text = user.profile.name
        }
        
    }
    
}
