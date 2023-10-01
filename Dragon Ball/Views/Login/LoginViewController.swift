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
    @IBOutlet weak var logInButton: UIButton!
    
    private let dragonBallApi = DragonBallAPIDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapLogIn(_ sender: Any) {
        dragonBallApi.login(user: userTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] result in
            switch result {
            case .success(_):
                    print("User authorized --> Successfully logged in")
                    self?.dragonBallApi.getCharacters { result in
                        switch result {
                            case let .success(characters):
                                DispatchQueue.main.async {
                                    self?.navigationController?.setViewControllers([CharacterViewController(characters: characters)], animated: true)
                                }
                            case let .failure(error):
                                print("DataLoadingError(Characters). Error description: \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print("LogInError. Error description: \(error.localizedDescription)")
            }
        }
    }
    
}


