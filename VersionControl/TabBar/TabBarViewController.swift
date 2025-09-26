//
//  TabBarViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let profileVC = ProfileViewController()
        
        let objectsVC = ObjectsViewController()
        let objectsVCPresenter = ObjectsViewPresenter()
        objectsVC.presenter = objectsVCPresenter
        objectsVCPresenter.delegate = objectsVC
        let navigationVC = UINavigationController(rootViewController: objectsVC)
        
        navigationVC.tabBarItem = UITabBarItem(
            title: "Обьекты",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: nil
        )
        
        viewControllers = [navigationVC, profileVC]
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
