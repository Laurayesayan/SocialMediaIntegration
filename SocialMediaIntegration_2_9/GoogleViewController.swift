//
//  GoogleViewController.swift
//  SocialMediaIntegration_2_9
//
//  Created by Лаура Есаян on 27.03.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

    }
    @IBAction func signOutFromGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
}
