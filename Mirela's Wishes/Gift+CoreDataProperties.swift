//
//  Gift+CoreDataProperties.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 07/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import CoreData


extension Gift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gift> {
        return NSFetchRequest<Gift>(entityName: "Gift");
    }

    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var details: String?
    @NSManaged public var importance: Int32
    @NSManaged public var photo: Photo?
    @NSManaged public var shop: Shop?
    @NSManaged public var type: Type?

}
