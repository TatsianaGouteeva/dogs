//
//  DogEntry+CoreDataProperties.swift
//  Dogs
//
//  Created by Inna Markevich on 23.07.22.
//
//

import Foundation
import CoreData

extension DogEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntry> {
        return NSFetchRequest<DogEntry>(entityName: "DogEntry")
    }

    @NSManaged public var breed: String
    @NSManaged public var weight: Double
    @NSManaged public var height: Double
    @NSManaged public var images: [String]?

}

extension DogEntry : Identifiable {

}
