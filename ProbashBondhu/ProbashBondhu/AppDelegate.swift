//
//  AppDelegate.swift
//  ProbashBondhu
//
//  Created by Pritam on 24/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupVC()
        return true
    }
    
    func setupVC() {
        showLoginScreen()
        //showHomeScreen()
    }
    
    func showLoginScreen() {
        if window == nil {
           window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        let vc = PBLoginViewController(nibName: "PBLoginViewController", bundle: nil)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func showHomeScreen() {
        if window == nil {
            window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        
        UINavigationBar.appearance().barTintColor = PBConstants.commonBlueColor
        
        let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
        vc.doctorID = PBLoginDataManager.shared.getDoctorID() ?? 0
        let nv = UINavigationController(rootViewController: vc)
        window?.rootViewController = nv
        window?.makeKeyAndVisible()
    }

}

