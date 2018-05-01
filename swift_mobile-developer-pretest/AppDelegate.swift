//
//  AppDelegate.swift
//  swift_mobile-developer-pretest
//
//  Created by Lin Cheng Lung on 2018/5/1.
//  Copyright © 2018 Lin Cheng Lung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let splitViewController = window!.rootViewController as? UISplitViewController else {
            return true
        }

        guard let navigationController = splitViewController.viewControllers.last as? UINavigationController else {
            return true
        }

        navigationController.topViewController!.navigationItem.leftBarButtonItem =
            splitViewController.displayModeButtonItem
        splitViewController.delegate = self

        return true
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else {
            return false
        }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing;
            // the secondary controller will be discarded.
            return true
        }
        return false
    }

}
