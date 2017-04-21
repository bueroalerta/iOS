//
//  MainNavigationController.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private Method
    private func setupStyle() {
        // Text Style
        navigationBar.titleTextAttributes = commonTextStyle()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        RootViewController.shared.navigationController?.setNavigationBarHidden(false, animated: false)
        super.pushViewController(viewController, animated: animated)
    }
}
