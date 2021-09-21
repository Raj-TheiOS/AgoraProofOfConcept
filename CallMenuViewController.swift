//
//  CallMenuViewController.swift
//  AgoraPOC
//
//  Created by Arjun  on 07/01/21.
//  Copyright © 2021 Raj. All rights reserved.
//

import UIKit

class CallMenuViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var channelTF: UITextField!
    var userData = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = UserDefaults.standard.value(forKey: "user")
        self.userData = user as! [String : String]
        self.userLabel.text = "Welcome "+"\(userData["username"] ?? "")"
        hideKeyboardWhenTappedAround()

    }
    @IBAction func didtapVideoCall(_ sender: Any) {
        if !channelTF.text!.isEmpty {
            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
            popOverVC.channel = self.channelTF.text!
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(popOverVC, animated: true)
        }else{
            let alert = UIAlertController(title: "Warning!", message: "Please Enter Channel!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didtapGroupCall(_ sender: Any) {
        if !channelTF.text!.isEmpty {
            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "AgoraVideoViewController") as! AgoraVideoViewController
            popOverVC.channelName = self.channelTF.text!
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(popOverVC, animated: true)
        }else{
            let alert = UIAlertController(title: "Warning!", message: "Please Enter Channel!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didtapStream(_ sender: Any) {
        if !channelTF.text!.isEmpty {
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Please select a role", preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let broadcasterButton = UIAlertAction(title: "Broadcaster", style: .default) { _ in
                let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "StreamingViewController") as! StreamingViewController
                popOverVC.channel = self.channelTF.text!
                popOverVC.userType = "Broadcaster"
                popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(popOverVC, animated: true)
            }
            actionSheetController.addAction(broadcasterButton)

            let audienceButton = UIAlertAction(title: "Audience", style: .default)
                { _ in
                   let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "StreamingViewController") as! StreamingViewController
                   popOverVC.channel = self.channelTF.text!
                   popOverVC.userType = "Audience"
                   popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                   self.present(popOverVC, animated: true)
            }
            actionSheetController.addAction(audienceButton)
            self.present(actionSheetController, animated: true, completion: nil)

        }else{
            let alert = UIAlertController(title: "Warning!", message: "Please Enter Channel!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func didtapUUID(_ sender: Any) {
        print(UUID())
    }
    
    @IBAction func didtapLogout(_ sender: Any) {
        self.resetDefaults()
        self.dismiss(animated: true, completion: nil)
    }

    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
