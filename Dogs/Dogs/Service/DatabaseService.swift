//
//  DatabaseService.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/23/22.
//

import Foundation

protocol DatabaseService {
    func fetchData() -> [Dog]
    func saveData(dog: Dog)
    func fetchDataFromJSON(from url: URL) -> [Dog]
}
