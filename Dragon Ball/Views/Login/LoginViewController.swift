//
//  LoginViewController.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 29/09/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        let model = NetworkModel()
        model.login(user: userTextField.text ?? "", password: passwordTextField.text ?? "") {result in
            switch result {
            case let .success(token):
                print("Token: \(token)")
//                model.getHeroes(token: token) { result in
//                    switch result {
//                    case let .success(heroes):
//                        print("Heroes: \(heroes)")
//                    case let .failure(error):
//                        print("Error: \(error)")
//                    }
//                }
            case let .failure(error):
                print("Error: \(error)")
            }
            
        }
    }
    
}
