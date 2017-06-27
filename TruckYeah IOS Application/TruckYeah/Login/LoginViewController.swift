//
//  LoginViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 1/20/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var usernameField: UITextField!
    
    @IBAction func loginAsGuestTapped(_ sender: UIButton) {
        self.parent?.performSegue(withIdentifier: SegueIdentifier.Root.showAllTrucks, sender: nil)
    }
    
    @IBAction func unwindFromTrucksMenu(_ sender: UIStoryboardSegue) {
        // nothing to do here, just unwind
        // might need to logout
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        guard let email = usernameField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self?.presentError(error)
                return
            }
        }
    }
    
    @IBAction func didTapLogin(_ sender: AnyObject) {
        guard let email = usernameField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self?.presentError(error)
                return
            }
            self?.parent?.performSegue(withIdentifier: SegueIdentifier.Root.showAllTrucks, sender: user)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)        
        }
    }
    
    func signedIn(_ user: FIRUser?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nick's notifier"), object: nil, userInfo: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for:segue, sender: sender)
        print("sender \(sender)")
    }
    
    private func presentError(_ error: Error) {
        let alert = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: false)
    }
    
}
