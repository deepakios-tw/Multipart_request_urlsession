//
//  AppDelegate.swift
//  urlsession_demo
//
//  Created by Apple on 20/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: Useful reference
/*
 Pickers

 https://theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/


 https://medium.com/@nkjagne1/document-picker-in-swift-4-db0bebe1347c

 https://theswiftdev.com/picking-and-playing-videos-in-swift/

 https://www.swiftbysundell.com/articles/http-post-and-file-upload-requests-using-urlsession/
 https://medium.com/@chris_42047/file-uploads-with-swift-d021e4012c12

 https://stackoverflow.com/questions/39676829/how-do-i-present-a-music-library-with-a-view-controller-for-a-mpmediapickercontr
 */

