//
//  ViewController.swift
//  Example
//
//  Created by Raúl Riera on 04/11/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit
import AuthenticationViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapAuthenticate(sender: UIButton) {
        let provider = OAuthDribbble(clientId: "your-client-id", clientSecret: "your-client-secret", scopes: ["public", "upload"])
        let authenticationViewController = AuthenticationViewController(provider: provider)
        
        authenticationViewController.failureHandler = { error in
            print(error)
        }
        
        authenticationViewController.authenticationHandler = { token in
            print(token)
            
            authenticationViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(authenticationViewController, animated: true, completion: nil)
    }

}

