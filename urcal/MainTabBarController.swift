//
//  NewTabBarController.swift
//  urcal
//
//  Created by Kilian Hiestermann on 02.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
   
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        let index = viewControllers?.index(of: viewController)
        
        if index == 2{
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoCreatorController(collectionViewLayout: layout)
            
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            present(navController, animated: true, completion: nil)
            
             return false
        } else{
            return true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
       if Auth.auth().currentUser == nil {
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
           
            }
        return
       
        }
        
        setupViewController()
        
    }

    func setupViewController() {
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "pin_unselected"), selectedImage: #imageLiteral(resourceName: "pin_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusPhotoNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        let bookmarkNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "bookmark_unselected"), selectedImage: #imageLiteral(resourceName: "bookmark"), rootViewController: BookmarkController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let userProfileController = UserPostsView()
        
        let userProfilenNavController = UINavigationController(rootViewController: userProfileController)
       
        userProfilenNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfilenNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [userProfilenNavController,
                           homeNavController,
                           plusPhotoNavController,
                           bookmarkNavController]
        
        
        
        guard let items = tabBar.items else { return }
        
        for item in items{
            
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController:  UIViewController = UIViewController()) -> UINavigationController{
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    
    }
    
}


