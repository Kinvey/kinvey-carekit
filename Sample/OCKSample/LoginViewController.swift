//
//  LoginViewController.swift
//  OCKSample
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-05.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Kinvey

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Kinvey.sharedClient.initialize(
            appKey: "",
            appSecret: ""
        ) { (result: Result<User?, Swift.Error>) in
            switch result {
            case .success(let user):
                if let user = user {
                    print(user)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Kinvey.sharedClient.activeUser != nil {
            performSegue(withIdentifier: Segue.autoLogin.rawValue, sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum Segue: String {
        
        case login = "Login"
        case autoLogin = "Auto Login"
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let segue = Segue(rawValue: identifier) {
            switch segue {
            case .login:
                Kinvey.sharedClient.logNetworkEnabled = true
                User.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", options: nil) {
                    switch $0 {
                    case .success(_):
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: identifier, sender: sender)
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
                return false
            case .autoLogin:
                return true
            }
        }
        return true
    }
    
    @IBAction
    func unwindToLogin(segue: UIStoryboardSegue) {
    }

}
