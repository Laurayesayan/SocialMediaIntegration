//
//  VKViewController.swift
//  SocialMediaIntegration_2_9
//
//  Created by Лаура Есаян on 30.03.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import VK_ios_sdk

class VKViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let scope = ["email", "wall"]
    
    var loggedIn = false {
        willSet {
            if newValue {
                if VKSdk.accessToken()?.localUser != nil {
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                    self.userImageView.setImage(url: (VKSdk.accessToken()?.localUser.photo_100)!)
                    self.nameLabel.text = (VKSdk.accessToken()?.localUser.last_name)! + " " + (VKSdk.accessToken()?.localUser.first_name)!
                }
            }
            else {
                self.userImageView.image = nil
                self.nameLabel.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !VKSdk.initialized() {
            VKSdk.initialize(withAppId: "7383867")?.uiDelegate = self
            VKSdk.instance()?.register(self)
        }
        
    }
    
    @IBAction func signInVK(_ sender: Any) {
        self.logIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: checkLog )
        
    }
    
    func checkLog() {
        if VKSdk.isLoggedIn() {
            self.loggedIn = true
        }
    }
    
    func logIn() {
        VKSdk.wakeUpSession(scope, complete:{ [weak self] (state: VKAuthorizationState, error: Error?) -> Void in
            if state == .authorized {
                let alertController = UIAlertController(title: "Logged in", message: "User already logged in.", preferredStyle: .alert)
                self?.present(alertController, animated: true) {
                    alertController.dismiss(animated: true, completion: nil)
                    self?.loggedIn = true
                }
            } else {
                VKSdk.authorize(self?.scope, with: .disableSafariController)
            }
            return
        })
    }
    
    @IBAction func logOut(_ sender: Any) {
        VKSdk.forceLogout()
        let alertController = UIAlertController(title: "Log out", message: "Success", preferredStyle: .alert)
        self.present(alertController, animated: true) {
            alertController.dismiss(animated: true, completion: nil)
        }
        loggedIn = false
    }

    @IBAction func shareToVK(_ sender: Any) {
        let vkShareLink = VKShareLink(title: "Test link", link: URL(string: "https://yandex.ru"))
        let vkShare = VKShareDialogController()
        vkShare.dismissAutomatically = true
        vkShare.shareLink = vkShareLink
        self.present(vkShare, animated: true, completion: nil)
    }
}

extension VKViewController: VKSdkUIDelegate, VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if (result.token != nil) {
            print("Success")
        } else if (result.error != nil) {
            let alertController = UIAlertController(title: "Log in error", message: "\(String(describing: result.error))", preferredStyle: .alert)
            self.present(alertController, animated: true) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Failed")
    }
    
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: {
                print("hide current modal controller if presents")
                self.present(controller, animated: true, completion: {
                    print("SFSafariViewController opened to login through a browser")
                })
            })
        } else {
            self.present(controller, animated: true, completion: {
                print("SFSafariViewController opened to login through a browser")
            })
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("Captcha error: \(captchaError.errorCode)")
    }
    
    
}
