//
//  AppDelegate.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 25/07/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let appModule = AppModule()
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initStoryboard()
        window.makeKeyAndVisible()
        return true
    }
    
    private func initStoryboard() {
        let locationViewController = storyboard.instantiateViewController(
            withIdentifier: NavigationConstants.locationViewController) as? LocationViewController
        window.rootViewController = locationViewController
        locationViewController?.appDelegate = self
        locationViewController?.appModule = appModule
    }
    
    func updateNavigationController(withIdentifier navigationIdentifier: String, _ changeRootViewController: Bool = true) {
        navigationController = storyboard.instantiateViewController(
            withIdentifier: navigationIdentifier) as? UINavigationController
        if changeRootViewController {
            window.rootViewController = navigationController
        }
    }
    
    func changeToRestaurantNavigationController(closure: @escaping (RestaurantTableViewController?) -> Void) {
        updateNavigationController(withIdentifier: NavigationConstants.restaurantNavigationController, false)
        if navigationController != nil {
            window.rootViewController?.present(navigationController!, animated: true) {
                let restaurantTableViewController = (self.navigationController!.topViewController as? RestaurantTableViewController)
                restaurantTableViewController?.presenter = self.appModule.provides()
                closure(restaurantTableViewController)
            }
        }
    }

}

struct NavigationConstants {
    static let locationViewController = "LocationViewController"
    static let restaurantNavigationController = "RestaurantNavigationController"
}
