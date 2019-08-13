//
//  AppDelegate.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-06.
//  Copyright © 2019 Rose H. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let stateController = StateController()
        guard let tabBarController = window?.rootViewController as? MainTabBarViewController,
            let viewControllers = tabBarController.viewControllers else {
                return true
        }

        
        let movieImage = UIImage(named: "Movie")
        let favouriteImage = UIImage(named: "FavouriteStar")
        
        viewControllers[0].tabBarItem.image = movieImage
        viewControllers[1].tabBarItem.image = favouriteImage

        for (index, viewController) in viewControllers.enumerated() {
            if let navigationController = viewController as? UINavigationController,
                let moviesViewController = navigationController.viewControllers.first as? MoviesViewController {
                navigationController.setNavigationBarHidden(true, animated: true)
                moviesViewController.stateController = stateController
                moviesViewController.favouritesOnly = index == 1
            }
        }
        return true
    }
}

