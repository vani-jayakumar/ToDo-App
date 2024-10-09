//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Vani on 10/3/24.
//

import UIKit
import FirebaseAuth
import FirebaseRemoteConfig
import FirebaseAnalytics

class HomeViewController: UIViewController {
    
   
    
    @IBOutlet weak var newEmailText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
   
    private var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(["email_label_text": "email" as NSObject])
        
        fetchRemoteConfigValues()
       
    }
    private func fetchRemoteConfigValues() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 1
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch {[weak self] status, error in
            if let error = error {
                print("Error fetching remoteConfig : \(error.localizedDescription)")
                return
            }
            self?.remoteConfig.activate{[weak self] changed, error in
                if let error = error {
                    print("Error activating remoteConfig: \(error.localizedDescription)")
                } else if  changed == true {
                    DispatchQueue.main.async {[weak self] in
                        self?.view.backgroundColor = .systemBlue
                    }
                    
                }
                self?.applyRemoteConfigValues()
            }
    }
}
    private func applyRemoteConfigValues() {
        let labelText = remoteConfig["email_label_text"].stringValue ?? "email"
        DispatchQueue.main.async {[weak self] in
            self?.emailLabel.text = labelText
        }
    }
    
    
    @IBAction private func didTapSignUp(button: UIButton){
        guard let email = newEmailText.text, !email.isEmpty,
              let password = newPasswordText.text, !password.isEmpty else {
            print("Email or password field is empty")
              return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as NSError? {
               
                print("Error signing up: \(error.localizedDescription)")
                
            } else {
                
                print("User signed up with email: \(authResult?.user.email ?? "No Email")")
                self?.navigatetoToDoViewController()
                Analytics.logEvent(AnalyticsEventSignUp, parameters: ["email": "email" as NSObject])
            }
        }
    }
    
    
    @IBAction private func didTapLogin(button: UIButton){
        let nextVC = NextViewController(nibName: "NextViewController", bundle: nil)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func navigatetoToDoViewController() {
            let todoVC = ToDoViewController(nibName: "ToDoViewController", bundle: nil)
        self.navigationController?.pushViewController(todoVC, animated: true)
        }
}



