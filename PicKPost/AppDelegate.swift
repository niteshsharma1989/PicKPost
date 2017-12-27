//
//  AppDelegate.swift
//  PicKPost
//
//  Created by IBAdmin on 27/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import FacebookCore
import CoreData
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
   var drawerController:KYDrawerController?
    var storyboard:UIStoryboard?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
         storyboard = UIStoryboard(name: Constants.MAIN, bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if let accessToken = FBSDKAccessToken.current()
        {
              print(" logged In.")
           launchHomeController()
        }
        else
        {
            print("Not logged In.")
            askForLoginWithFacebook()
        }
        

        return true
    }
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    
    public func application(_ application: UIApplication, open url: URL,     sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
   
    func launchHomeController()
    {
        
       
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.HOME_CONTROLLER_ID)//  landing
        let drawerViewController  = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.DRAWER_CONTROLLER_ID)
        drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        drawerController?.drawerViewController = drawerViewController
       
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
       
    }
    
    func setAllPhotosViewControllerInDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.ALL_PHOTOS_CONTROLLER_ID)//  landing
        
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
      
        
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
      
        
       
        
    }
    func setProfileViewControllerInDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.HOME_CONTROLLER_ID)//  landing
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
        
    }
    func setAllFacebookInDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.ALL_FACEBOOK_PHOTOS_CONTROLLER_ID)//  landing
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
        
    }
    func setAllFacebookFriendsInDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.ALL_FACEBOOK_FRIENDS_CONROLLER_ID)//  landing
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
        
    }
    
    func setFacebookFeedsInDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.FACEBOOK_FEEDS_CONTROLLER_ID)//  landing
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
        
    }
    
    func setNavigationDrawerMainController()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.NAVIGATION_CONTROLLER_ID)//  landing
        drawerController?.mainViewController = UINavigationController(rootViewController: mainViewController)
        if let window = self.window
        {
            window.rootViewController = drawerController
        }
        
    }
    func closeDrawer()
    {
        drawerController?.setDrawerState(.closed, animated: true)
        
    }
    
    func askForLoginWithFacebook()
    {
        let mainViewController   = storyboard!.instantiateViewController(withIdentifier: StoryBoardIDs.FACEBOOK_LOGIN_CONTROLLER_ID)//  landing
        if let window = self.window
        {
            window.rootViewController = mainViewController
        }
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
        let container = NSPersistentContainer(name: "PicKPost")
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

