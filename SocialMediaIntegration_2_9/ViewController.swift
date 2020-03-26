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
import FacebookCore

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var loggedIn = false {
        willSet {
            if newValue {
                getUserData()
            } else {
                self.imageView.image = nil
                self.nameLabel.text = ""
            }
        }
    }
    
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
            loginManager.logIn(permissions: [.publicProfile, .userFriends], viewController: self) { [weak self] result in
                self?.loginManagerDidComplete(result)
                self?.loggedIn = true
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
        
        loggedIn = false
    }
    
    func shareLink(url: String) {
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: url)!
        shareContent.quote = "Bull shit"

        let shareDialog = ShareDialog()
        shareDialog.mode = .web
        shareDialog.shareContent = shareContent
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        shareDialog.show()
    }
    
    @IBAction func facebookShare(_ sender: UIButton) {
        shareLink(url: "https://github.com/facebookarchive/facebook-swift-sdk/blob/master/Samples/Catalog/Sources/ShareDialogViewController.swift")
    }

}

extension ViewController: SharingDelegate {
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
    
    func getUserData() {
        let request = GraphRequest(graphPath: "me",
                                   parameters: ["fields": "name, picture.type(normal)"],
                                   httpMethod: .get)
        request.start { [weak self] _, result, error in
            switch (result, error) {
            case let (result?, nil):
                self?.getDataFromJSON(requestResult: result)
            case let (nil, error?):
                print("Graph Request Failed: \(error)")
            case (_, _):
                print("Graph Request Failed: unknown error")
            }
        }
    }
    
    func getDataFromJSON(requestResult: Any?) {
        if let json = requestResult as? NSDictionary {
            self.nameLabel.text = json["name"] as? String
            if let picture = json["picture"] as? NSDictionary {
                if let data = picture["data"] as? NSDictionary {
                    self.imageView.layer.cornerRadius = (self.imageView.frame.width) / 2
                    self.imageView.setImage(url: data["url"] as! String)
                }
            }
        }
    }
    
}

extension UIImageView {
    func setImage(url: String) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global(qos: .background).async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async { [weak self] in
                self!.image = image
            }
        }
    }
}
