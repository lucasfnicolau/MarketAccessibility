//
//  CDManager.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit
import CoreData

func getAppDelegate() -> AppDelegate {
    return (UIApplication.shared.delegate as? AppDelegate) ?? AppDelegate()
}

func getContext() -> NSManagedObjectContext {
    return getAppDelegate().persistentContainer.viewContext
}

func saveContext() {
    getAppDelegate().saveContext()
}
