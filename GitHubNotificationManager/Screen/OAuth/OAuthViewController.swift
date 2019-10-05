//
//  OAuthViewController.swift
//  GitHubNotificationManager
//
//  Created by Yudai.Hirose on 2019/10/04.
//  Copyright © 2019 bannzai. All rights reserved.
//

import UIKit
import OAuthSwift
import GitHubNotificationManagerCore
import AuthenticationServices

public class OAuthViewController: UIViewController {
    struct Const {
        static let callbackHost = "oauth-callback"
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    var oauth: OAuth2Swift!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func authorizeButtonPressed(_ sender: Any) {
        authorize()
    }

    func authorize() {
        oauth = OAuth2Swift(
            consumerKey: Secret.GitHub.clientId,
            consumerSecret: Secret.GitHub.clientSecret,
            authorizeUrl: "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType: "code"
        )
        oauth.authorizeURLHandler = SafariURLHandler(
            viewController: self,
            oauthSwift: oauth
        )
        oauth.authorize(
            withCallbackURL: URL(string: Secret.Application.callbackURLSchema + Const.callbackHost),
            scope: "notifications",
            state: "\(Date().timeIntervalSince1970)") { (result: Result<OAuthSwift.TokenSuccess, OAuthSwiftError>) in
                switch result {
                case .success(let token):
                    print(token)
                case .failure(let error):
                    print(error)
                }
        }
    }
}