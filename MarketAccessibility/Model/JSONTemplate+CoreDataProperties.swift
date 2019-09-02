//
//  JSONTemplate+CoreDataProperties.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import Foundation
import CoreData
    
extension JSONTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JSONTemplate> {
        return NSFetchRequest<JSONTemplate>(entityName: "JSONTemplate")
    }

    @NSManaged public var content: String?

}
