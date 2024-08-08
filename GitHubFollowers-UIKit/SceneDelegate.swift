//
//  SceneDelegate.swift
//  GitHubFollowers-UIKit
//
//  Created by Richard Basdeo on 8/8/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    //will connect to is the first thing that runs
    //almost like did finish launching with options
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        //take up the whole screen
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        //give our window a scene
        window?.windowScene = windowScene
        
        //tab bar holds navigation controllers
        window?.rootViewController = createTabBar()
        //Just says display the view controller I chose
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
    }
    
    //create tab bar with desired tabs
    private func createTabBar () -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        
        //Put the tabs in the order I want them
        tabBar.viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
        
        return tabBar
    }
    
    //Navigation contoller for the search tab
    private func createSearchNavigationController () -> UINavigationController {
        let searchNavigationController = SearchVC()
        searchNavigationController.title = "Search"
        searchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchNavigationController)
    }
    
    //Navigation contoller for the favorites tab
    private func createFavoritesNavigationController () -> UINavigationController {
        let favrotiesListVC = FavoritesListVC()
        favrotiesListVC.title = "Favorites"
        favrotiesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favrotiesListVC)
    }
    
    func configureNavigationBar(){
        //when using appearnce all of the UI elements will have the same color
        UINavigationBar.appearance().tintColor = .systemGreen
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

