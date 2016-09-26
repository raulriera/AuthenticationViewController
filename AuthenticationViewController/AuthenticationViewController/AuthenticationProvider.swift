//
//  AuthenticationProvider.swift
//  AuthenticationViewController
//
//  Created by Raúl Riera on 04/11/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import Foundation

/**
 The AuthenticationProvider protocol includes the contract that every provider must follow in order to be compatible with instances of the AuthenticationViewController.
 */
public protocol AuthenticationProvider {
    /// A string that will be used in the navigation bar item of the SFSafariViewController.
    var title: String? { get }
    /// A string containing your client's id
    var clientId: String { get }
    /// A string containing your client's secret
    var clientSecret: String { get }
    /// The URL to authenticate against to and retrieve the authorization code.
    var authorizationURL: URL { get }
    /// The URL to exchange the authorization code for an actual access token
    var accessTokenURL: URL { get }
    /// The dictionary of extra parameters that will be sent to the `accessTokenURL`, you don't need to concern yourself about anything that you have already supplied or the code received from the `authorizationURL`
    var parameters: [String: String] { get }
    /// The permissions being requested from the provider. Refer to the provider's documentation on what these values should be
    var scopes: [String] { get }
    
    init(clientId: String, clientSecret: String, scopes: [String])
}
