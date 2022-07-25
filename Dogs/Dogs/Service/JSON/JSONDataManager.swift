//
//  JSONDataManager.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

import Foundation

final class JSONDataManager {
    static func fetchDataFromJSON() -> [Dog] {
        JSONLoader.shared.load(from: "dogs").orEmpty
    }
}
