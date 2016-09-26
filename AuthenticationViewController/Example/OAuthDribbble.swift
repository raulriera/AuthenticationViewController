//
//  OAuthDribbble.swift
//  AuthenticationViewController
//
//  Created by Raul Riera on 03/11/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import Foundation
import AuthenticationViewController

struct OAuthDribbble: AuthenticationProvider {
    
    let title: String?
    let clientId: String
    let clientSecret: String
    let scopes: [String]
    
    var authorizationURL: URL {
        return URL(string: "https://dribbble.com/oauth/authorize?client_id=\(clientId)&scope=\(scopes.joined(separator: "+"))")!
    }
    
    var accessTokenURL: URL {
        return URL(string: "https://dribbble.com/oauth/token")!
    }
    
    var parameters = ["":""]
    
    // MARK: Initialisers
    
    init(clientId: String, clientSecret: String, scopes: [String]) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.title = "Dribbble"
    }
}
