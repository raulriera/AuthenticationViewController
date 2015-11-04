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
 
 - InvalidToken:		The token retrieved was incorrect.
 - InvalidRequest:      There was an error in the request performed. A `NSError` instance is associated to this case.
 - URLResponseError:	There was an error in the token retrieving process. The whole `NSURLResponse` is associated to this case.
 */
public enum AuthenticationError: ErrorType {
    case InvalidToken
    case InvalidRequest(NSError)
    case URLResponseError(NSURLResponse)
}

/**
 The AuthenticationViewController class provides a standard interface for authenticating to oauth 2.0 protected endpoints via SFSafariViewController.
 */
public class AuthenticationViewController: UINavigationController {
    
    public typealias AuthenticationHandler = ([String: AnyObject]) -> Void
    public typealias FailureHandler = (AuthenticationError) -> Void
    /// A closure called when the authentication token is retrieved
    public var authenticationHandler: AuthenticationHandler?
    /// A closure called when an error occurs in any of the authentication step
    public var failureHandler: FailureHandler?
    
    private let provider: AuthenticationProvider
    
    // MARK: Initialisers
    
    /**
    Returns a newly initialized authentication view controller with the specified provider.
    
    - parameter provider:	The provider to authenticate against to
    
    - returns: A newly initialized AuthenticationViewController object.
    */
    public init(provider: AuthenticationProvider) {
        self.provider = provider
        
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported. Did you mean to use init(provider:)?")
    }
    
    // MARK: View Controller Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let authenticationURL = provider.authorizationURL
        let safariViewController = SFSafariViewController(URL: authenticationURL)
        safariViewController.title = provider.title
        
        setViewControllers([safariViewController], animated: false)
    }
    
    // MARK: Authentication
    
    /**
    Initiates the process of exchanging the authentication code for an actual authentication token. If everything goes well the `AuthenticationHandler` will be executed, otherwise listen for the `FailureHandler`.
    
    - parameter code:	The authorization code retrieved
    */
    public func authenticateWithCode(code: String) {
        let request = NSMutableURLRequest(URL: provider.accessTokenURL)
        let parameters = provider.parameters.map { key, value in
            "\(key)=\(value)"
            }.joinWithSeparator("&")
        let data = "client_id=\(provider.clientId)&client_secret=\(provider.clientSecret)&code=\(code)&\(parameters)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { [unowned self] (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                
                guard error == .None else {
                    self.failureHandler?(.InvalidRequest(error!))
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse where 200..<300 ~= httpResponse.statusCode else {
                    self.failureHandler?(.URLResponseError(response!))
                    return
                }
                
                guard let data = data else {
                    self.failureHandler?(.InvalidToken)
                    return
                }
                
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                            self.authenticationHandler?(json)
                    }
                } catch {
                    self.failureHandler?(.URLResponseError(httpResponse))
                }
                
            }
        }.resume()
    }
    
}