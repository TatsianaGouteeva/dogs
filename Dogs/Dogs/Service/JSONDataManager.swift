//
//  JSONDataManager.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

import Foundation

final class JSONDataManager {
    static func fetchDataFromJSON() -> [Dog] {

        var dogs: [Dog] = []
        do {
            dogs = JSONLoader.shared.load(from: "dogs")!
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        return dogs
    }
}
