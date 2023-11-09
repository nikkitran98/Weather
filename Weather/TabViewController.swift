//
//  TabViewController.swift
//  Weather
//
//  Created by Nikki Tran on 10/13/23.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tab1 = WeatherViewController()
        tab1.title = "Weather"
        let tab2 = SettingsViewController()
        tab2.title = "Settings"
        
        let nav1 = UINavigationController(rootViewController: tab1)
        let nav2 = UINavigationController(rootViewController: tab2)
        
        nav1.tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        self.setViewControllers([nav1, nav2], animated: true)
    }
    
    @objc private func fetchMovies() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=67cef2a15373a95690491206f68a2f7d") else { return }
    }
}
