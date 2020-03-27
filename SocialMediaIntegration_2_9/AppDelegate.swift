//
//  AppDelegate.swift
//  SocialMediaIntegration_2_9
//
//  Created by Лаура Есаян on 23.03.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import FacebookCore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
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
            print(user.profile.name ?? "No name")
        }
        
      // Perform any operations on signed in user here.
//      let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "676507984305-78r8vok60pr06ao8kvo3hmam470s8kec.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return
//    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return ApplicationDelegate.shared.application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url)
    }
    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//      return GIDSignIn.sharedInstance().handle(url)
//    }

}

