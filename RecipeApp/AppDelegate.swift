//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Simranjot Kaur on 2024-04-10.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Core Data stack
        CoreDataStack.shared.loadPersistentStore()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save changes in the application's managed object context when the application terminates.
        CoreDataStack.shared.saveContext()
    }
}
    
    class CoreDataStack {
        static let shared = CoreDataStack()

        private init() {}

        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SavedRecipesModel") // Replace with your data model name
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

        func loadPersistentStore() {
            _ = persistentContainer // This line loads the persistent store
        }

        func saveContext() {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

}

