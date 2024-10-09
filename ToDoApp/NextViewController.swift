//
//  NextViewController.swift
//  ToDoApp
//
//  Created by Vani on 10/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class NextViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction private func didtapLogin(button : UIButton){
        guard let email = emailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
              return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
            } else {
            print("User logged in with email: \(authResult?.user.email ?? "No Email")")
            self?.navigatetoToDoViewController()
                Analytics.logEvent(AnalyticsEventLogin, parameters: ["email": "email" as NSObject])
            }
        }
        
    }
    @IBAction private func didtapSignUp(button: UIButton){
        let homeVc = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
    private func navigatetoToDoViewController() {
            let todoVC = ToDoViewController(nibName: "ToDoViewController", bundle: nil)
        self.navigationController?.pushViewController(todoVC, animated: true)
        }

}
