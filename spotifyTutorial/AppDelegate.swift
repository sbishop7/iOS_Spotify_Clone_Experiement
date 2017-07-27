//
//  AppDelegate.swift
//  spotifyTutorial
//
//  Created by Daniel Thompson on 7/24/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import UIKit
import CoreData
import SafariServices


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingDelegate {

    var window: UIWindow?
    
    var auth = SPTAuth.defaultInstance()!
    var player = SPTAudioStreamingController.sharedInstance()!
    var authViewController: UIViewController!
    
    var authURL: URL!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        auth.clientID = "ae9d84e70f4b4ba487165a760dbb8b31"
        auth.redirectURL = URL(string: "dojospotifyapp://authentication")
        auth.sessionUserDefaultsKey = "current session"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        
        player.delegate = self
        
        do {
            try player.start(withClientId: auth.clientID)
        } catch {
            print(String(describing: error))
        }
        
        DispatchQueue.main.async {
            self.startAuthenticationFlow()
        }
        
        
        
        return true
    }
    
    func startAuthenticationFlow(){
        if auth.session != nil && auth.session.isValid() {
            player.login(withAccessToken: auth.session.accessToken)
        } else {
            authURL = auth.spotifyWebAuthenticationURL()
            authViewController = SFSafariViewController(url: authURL)
            window?.rootViewController?.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if auth.canHandle(url) { // is the incoming url a spotify authentication url?
            // close the authentication window
            authViewController.presentingViewController?.dismiss(animated: true, completion: nil)
            self.authViewController = nil
            
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: {
            (error, session) in
                if let authError = error {
                    print("auth error: \(String(describing: authError.localizedDescription))")
                }
                
                if session != nil {
                    self.player.login(withAccessToken: self.auth.session.accessToken)
                    do {
                        
                        let request = try SPTBrowse.createRequestForNewReleases(inCountry: nil, limit: 10, offset: 0, accessToken: self.auth.session.accessToken)
                        let session = URLSession.shared
                        let dataTask = session.dataTask(with: request) {
                            data, response, error in
                                print("data is... \(data!)")
                        }
                        dataTask.resume()
                        
                    } catch {
                        print("didn't work")
                    }
                    
                }
                
                // archived flow for saving session to UserDefaults
                
//                let userDefaults = UserDefaults.standard
//                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session!)
//                print(sessionData)
//                userDefaults.set(sessionData, forKey: "SpotifySession")
//                userDefaults.synchronize()
//                NotificationCenter.default.post(name: Notification.Name("loginSuccessful"), object: nil)
            })
            return true
        }
        return false
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print("audioStreamingDidLogin")
//        player.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: {
//        (error) in
//            if let streamingError = error {
//                print("error in playSpotifyURI \(String(describing: streamingError.localizedDescription))")
//            }
//        })
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "spotifyTutorial")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

