//
//  User+CoreDataProperties.swift
//  
//
//  Created by Mauricio Garza on 12/3/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var emotion: String?
    @NSManaged public var faceId: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: Data?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var visits: Int64

}
