//
//  ViewController.swift
//  On The Map
//
//  Created by Thomas Milgrew on 11/12/17.
//  Copyright © 2017 Thomas Milgrew. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //Properties
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            debugTextLabel.text = "Enter Username and/or Password"
        } else {
            UdacityClient.sharedInstance().authenticate(emailTextField.text!, passwordTextField.text!, self) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.debugTextLabel.text = "SUCCESS!!"
                        self.completeLogin()
                    } else {
                        self.displayError("\(errorString)")
                    }
                }
            }
        
        
        }
    }
    
    
    private func completeLogin(){
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}






