# AuthenticationViewController
A simple to use, standard interface for authenticating to OAuth 2.0 protected endpoints via SFSafariViewController.

## Instructions
In order to use this View Controller you need to be running iOS 9 on your simulator or device.

### Step 1
Setup the URL Scheme of your app as shown in the image below. (You can find this in the Info tab of your project's settings)

![Step1](/Screenshots/Step1.png)

### Step 2
Prepare your `AppDelegate` to handle this newly created URL Scheme

```swift
func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {

        // Before doing this, you should check the url is your redirect-uri before doing anything. Be safe :)
        if let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems, let code = queryItems.first?.value {

            // Let's find the instance of our authentication controller, it would be the presentedViewController. This is another reason to check before that we are actually coming from the SFSafariViewController
            if let rootViewController = window?.rootViewController, let authenticationViewController = rootViewController.presentedViewController as? AuthenticationViewController {
                authenticationViewController.authenticateWithCode(code)
            }

            return true
        }

        return false

    }
```

Note that you need to pass the `authentication code` received by your URL scheme to the `AuthenticationViewController` so it can exchange it for an actual `access token`.

### Step 3
Create an `AuthenticationProvider` following the `AuthenticationProvider` protocol.

### Step 4
Instantiate an `AuthenticationViewController` in your code and pass in the provider.

```swift
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
```

That is it, when you fill in your user account in the `AuthenticationViewController` and if everything went correctly you should get the `access token` in the `authenticationHandler` closure. Otherwise check for any errors in the `failureHandler` closure.

## Example

Sometimes it's easier to dig in into some code, included in this project is an example for Dribbble and Instagram. You will still need to edit the source code to provide real `clientId`, `clientSecret`, and your `URL scheme`.

## Created by
Raul Riera, [@raulriera](http://twitter.com/raulriera)
