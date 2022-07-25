//
//  DatabaseService.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/23/22.
//

import Foundation

protocol DatabaseServiceProtocol {
    var isEmpty: Bool { get }
    
    func fetchData() -> [Dog]
    func fetchDataFromBase() -> [Dog]
    func fetchDataFromJSON() -> [Dog]
    func saveData(dog: Dog)
}

final class DatabaseService {

    private let service: DatabaseServiceProtocol = Settings.shared.activeDatabaseConfiguration

    var isEmpty: Bool {
        service.isEmpty
    }
    
    func fetchData() -> [Dog] {
        isEmpty ? service.fetchDataFromJSON() : service.fetchData()
    }

    func saveData(dog: Dog) {
        service.saveData(dog: dog)
    }
}
