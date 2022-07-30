//
//  DogEntity+CoreDataProperties.swift
//  Dogs
//
//  Created by Inna Markevich on 23.07.22.
//
//

import Foundation
import CoreData

extension DogEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntity> {
        return NSFetchRequest<DogEntity>(entityName: "DogEntity")
    }

    @NSManaged public var breed: String
    @NSManaged public var weight: Double
    @NSManaged public var height: Double
    @NSManaged public var images: [String]?

}

extension DogEntity : Identifiable {

}
