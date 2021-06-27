//
//  ViewController.swift
//  vkApp
//
//  Created by Юля on 25.06.21.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkUIDelegate, VKSdkDelegate {
    
    let appId = "7888116"
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let sdkInstance = VKSdk.initialize(withAppId: self.appId)
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        vkLogin()
    }
    
    func vkLogin() {
        print("vkLogin()")
        let scope = ["wall", "friends"]
        VKSdk.instance().uiDelegate = self
        VKSdk.instance().register(self)
        VKSdk.wakeUpSession(scope) {
            state, error in
            if (state == VKAuthorizationState.authorized) {
                VKSdk.forceLogout()
            } else {
                VKSdk.authorize(scope, with: .disableSafariController)
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        guard result.token != nil else {
            print("Failure")
            return
        }
        print("Success!")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: {
                self.present(controller, animated: true, completion: {
                })
            })
        } else {
            self.present(controller, animated: true, completion: {
            })
        }
        print("present")
    }
    
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        self.performSegue(withIdentifier: "tabBarSegue", sender: Any?.self)
        
        print("finish")
    }

    func vkSdkUserAuthorizationFailed() {
        print("Failed")
    }

    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(captchaError)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBarSegue" {
            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers![0] as! NewsViewController
            destinationViewController.token = token!
        }
    }

}

