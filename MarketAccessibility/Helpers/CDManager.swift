//
//  CDManager.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit
import CoreData

// MARK: - Core Data stack

var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "MarketAccessibility")
    container.loadPersistentStores(completionHandler: { (_, error) in
        if let error = error as NSError? {

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

            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

func getAppDelegate() -> AppDelegate {
    return (UIApplication.shared.delegate as? AppDelegate) ?? AppDelegate()
}

func getContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
}
