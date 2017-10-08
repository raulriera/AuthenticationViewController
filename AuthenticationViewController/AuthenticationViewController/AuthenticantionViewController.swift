//
//  AuthenticantionViewController.swift
//  AuthenticantionViewController
//
//  Created by Raúl Riera on 31/10/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import Foundation
import SafariServices

/**
 The types of errors that this class can return in the `failureHandler`.
 
 - invalidToken:		The token retrieved was incorrect.
 - invalidRequest:      There was an error in the request performed. A `NSError` instance is associated to this case.
 - userCancelled:       The user closed the authentication view controller on its own.
 - urlResponseError:	There was an error in the token retrieving process. The whole `NSURLResponse` is associated to this case.
 */
public enum AuthenticationError: Error {
    case invalidToken
    case invalidRequest(Error)
    case userCancelled
    case urlResponseError(URLResponse)
}

/**
The AuthenticationViewController class provides a standard interface for authenticating to oauth 2.0 protected endpoints via SFSafariViewController.

Use the `AuthenticationHandler` and or `FailureHandler` to dismiss the View Controller once you are finished with the authentication.
*/
open class AuthenticationViewController: SFSafariViewController {
	public typealias AuthenticationHandler = ([String: AnyObject]) -> Void
	public typealias FailureHandler = (AuthenticationError) -> Void
	/// A closure called when the authentication token is retrieved
	open var authenticationHandler: AuthenticationHandler?
	/// A closure called when an error occurs in any of the authentication step
	open var failureHandler: FailureHandler?
	let provider: AuthenticationProvider
	
	required public init(provider: AuthenticationProvider) {
		self.provider = provider
		
		super.init(url: provider.authorizationURL, entersReaderIfAvailable: false)
	}
	
	/**
	Initiates the process of exchanging the authentication code for an actual authentication token. If everything goes well the `AuthenticationHandler` will be executed, otherwise listen for the `FailureHandler`.
	
	- parameter code:	The authorization code retrieved
	*/
	open func authenticateWithCode(_ code: String) {
		let request = NSMutableURLRequest(url: provider.accessTokenURL as URL)
		let parameters = provider.parameters.map { key, value in
			"\(key)=\(value)"
			}.joined(separator: "&")
		let data = "client_id=\(provider.clientId)&client_secret=\(provider.clientSecret)&code=\(code)&\(parameters)"
		
		request.httpMethod = "POST"
		request.httpBody = data.data(using: String.Encoding.utf8)
		
		URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) in
			DispatchQueue.main.async {
				
				guard error == nil else {
					self.failureHandler?(.invalidRequest(error!))
					return
				}
				
				guard let httpResponse = response as? HTTPURLResponse , 200..<300 ~= httpResponse.statusCode else {
					self.failureHandler?(.urlResponseError(response!))
					return
				}
				
				guard let data = data else {
					self.failureHandler?(.invalidToken)
					return
				}
				
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
						self.authenticationHandler?(json)
					}
				} catch {
					self.failureHandler?(.urlResponseError(httpResponse))
				}
				
			}
			}.resume()
	}
}
