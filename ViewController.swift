//
//  ViewController.swift
//  AgoraPOC
//
//  Created by Arjun  on 07/01/21.
//  Copyright © 2021 Raj. All rights reserved.
//

import UIKit
import AgoraRtcKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var userObject = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is our usual steps for joining
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didtapLogin(_ sender: Any) {
        if !userTF.text!.isEmpty  && !passwordTF.text!.isEmpty{
            userObject = ["username":userTF.text!,"password":passwordTF.text!]
            UserDefaults.standard.set(userObject, forKey: "user")
            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "CallMenuViewController") as! CallMenuViewController
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(popOverVC, animated: true)
        }else{
            let alert = UIAlertController(title: "Warning!", message: "Please Enter username and password!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController{
    
    // MARK: Hide keyboard
       func hideKeyboardWhenTappedAround() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
       @objc func dismissKeyboard() {
           view.endEditing(true)
       } // uasge  hideKeyboardWhenTappedAround()
}
