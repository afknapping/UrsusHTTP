//
//  ViewController.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/08/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit
import PromiseKit
import Ursus

class ViewController: UIViewController {
    
    // MARK: State
    
    private var auth: Auth?
    
    // MARK: Interface outlets
    
    @IBOutlet var shipTextField: UITextField!
    @IBOutlet var codeTextField: UITextField!
    
    @IBOutlet var authenticateButton: UIButton!
    @IBOutlet var deauthenticateButton: UIButton!
    @IBOutlet var clickButton: UIButton!
    
    // MARK: Interface actions
    
    @IBAction func authenticateButtonTapped() {
        authenticate(withShip: shipTextField.text!, andCode: codeTextField.text!)
    }
    
    @IBAction func deauthenticateButtonTapped() {
        deauthenticate(withShip: auth!.user!, andOryx: auth!.oryx!)
    }
    
    @IBAction func clickButtonTapped() {
        click(withXyro: "click", andOryx: auth!.oryx!)
    }
    
    // MARK: Interface state
    
    private enum State {
        case Authenticating
        case Authenticated
        case Deauthenticating
        case Deauthenticated
    }
    
    private func setState(state: State) {
        shipTextField.enabled = state == .Deauthenticated
        codeTextField.enabled = state == .Deauthenticated
        
        shipTextField.backgroundColor = state == .Deauthenticated ? UIColor.whiteColor() : UIColor.lightGrayColor()
        codeTextField.backgroundColor = state == .Deauthenticated ? UIColor.whiteColor() : UIColor.lightGrayColor()
        
        authenticateButton.enabled = state == .Deauthenticated
        deauthenticateButton.enabled = state == .Authenticated
        
        authenticateButton.hidden = state == .Authenticated || state == .Deauthenticating
        deauthenticateButton.hidden = state == .Deauthenticated || state == .Authenticating
        
        clickButton.enabled = state == .Authenticated
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(.Deauthenticated)
    }
    
    // MARK: Requests
    
    /*
     These methods authenticate and deauthenticate your session.
     
     See http://urbit.org/docs/arvo/internals/eyre/specification/#-1-3-authentication
     */
    
    private func authenticate(withShip ship: String, andCode code: String) {
        setState(.Authenticating)
        
        Ursus.GETAuth().then { auth -> Promise<Auth> in
            return Ursus.PUTAuth(oryx: auth.oryx!, ship: ship, code: code)
        }.then { auth in
            self.presentAlertController(withTitle: "Authentication success", message: "Logged in as ~\(auth.user!)") {
                self.auth = auth
                self.setState(.Authenticated)
            }
        }.error { error in
            self.presentAlertController(withTitle: "Authentication error", message: (error as NSError).localizedDescription) {
                self.setState(.Deauthenticated)
            }
        }
    }
    
    private func deauthenticate(withShip ship: String, andOryx oryx: String) {
        setState(.Deauthenticating)
        
        Ursus.DELETEAuth(oryx: oryx, ship: ship).then { auth in
            self.presentAlertController(withTitle: "Deauthentication success", message: "Logged out") {
                self.auth = nil
                self.setState(.Deauthenticated)
            }
        }.error { error in
            self.presentAlertController(withTitle: "Deauthentication error", message: (error as NSError).localizedDescription) {
                self.setState(.Authenticated)
            }
        }
    }
    
    /*
     This method sends a message to the `examples-click` application, if you have it running.
     
     See https://github.com/urbit/examples/tree/d3ac46d8f68335cb4dcf178e3953a829655d9a82/gall/click
     */
    
    private func click(withXyro xyro: String, andOryx oryx: String) {
        Ursus.POSTTo(appl: "examples-click", mark: "examples-click-clique", oryx: oryx, wire: "/", xyro: xyro).then { object in
            self.presentAlertController(withTitle: "Click success")
        }.error { error in
            self.presentAlertController(withTitle: "Click error", message: (error as NSError).localizedDescription)
        }
    }
    
    // MARK: Alerts
    
    private func presentAlertController(withTitle title: String, message: String? = nil, handler: (Void -> Void)? = nil) {
        let viewController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        viewController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            handler?()
        }))
        presentViewController(viewController, animated: true, completion: nil)
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case shipTextField:
            codeTextField.becomeFirstResponder()
        case codeTextField:
            authenticate(withShip: shipTextField.text!, andCode: codeTextField.text!)
        default:
            break
        }
        
        return true
    }
    
}
