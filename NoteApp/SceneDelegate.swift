//
//  SceneDelegate.swift
//  NoteApp
//
//  Created by דוד נוי on 06/06/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, LocationManagerDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check location permissions
        let locationManager = LocationManager()
        locationManager.delegate = self
        locationManager.checkLocationAuthorizationStatus()
        
        // Check if user is logged in
        if UserDefaults.standard.bool(forKey: Strings.isLoggedInKey) {
            
            // Navigate to MainTabBarController
            let mainTabBarController = UIStoryboard(name: Strings.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Strings.mainTabBarController) as! UITabBarController
            window?.rootViewController = mainTabBarController
        } else {
            
            // Navigate to LoginViewController
            let loginVC = UIStoryboard(name: Strings.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Strings.loginViewController) as! LoginViewController
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
        
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.ok, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
    }
}

