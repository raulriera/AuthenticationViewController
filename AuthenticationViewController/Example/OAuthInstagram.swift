//
//  OAuthInstagram.swift
//  AuthenticationViewController
//
//  Created by Raul Riera on 04/11/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import Foundation
import AuthenticationViewController

struct OAuthInstagram: AuthenticationProvider {
    
    let title: String?
    let clientId: String
    let clientSecret: String
    let scopes: [String]
    
    let redirectURI = "your-redirect-uri" // this is required for Instagram
    
    var authorizationURL: URL {
        return URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(clientId)&scope=\(scopes.joined(separator: "+"))&redirect_uri=\(redirectURI)&response_type=code")!
    }
    
    var accessTokenURL: URL {
        return URL(string: "https://api.instagram.com/oauth/access_token")!
    }
    
    var parameters: [String: String] {
        return ["grant_type": "authorization_code", "redirect_uri": redirectURI]
    }
    
    // MARK: Initialisers
    
    init(clientId: String, clientSecret: String, scopes: [String]) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.title = "Instagram"
    }
}
