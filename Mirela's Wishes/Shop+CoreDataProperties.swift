//
//  Shop+CoreDataProperties.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 07/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop");
    }

    @NSManaged public var name: String?
    @NSManaged public var type: NSSet?

}

// MARK: Generated accessors for type
extension Shop {

    @objc(addTypeObject:)
    @NSManaged public func addToType(_ value: Type)

    @objc(removeTypeObject:)
    @NSManaged public func removeFromType(_ value: Type)

    @objc(addType:)
    @NSManaged public func addToType(_ values: NSSet)

    @objc(removeType:)
    @NSManaged public func removeFromType(_ values: NSSet)

}
