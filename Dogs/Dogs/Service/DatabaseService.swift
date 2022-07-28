//
//  DatabaseService.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/23/22.
//

import Foundation

typealias FetchResult = Result<[Dog], Error>

protocol DatabaseServiceProtocol {
    func checkemptyDatabase(completion: @escaping(Bool) -> Void)
    func fetchDataFromBase(completion: @escaping(FetchResult) -> Void)
    func fetchDataFromJSON() -> [Dog]
    func fetchData(completion: @escaping(FetchResult) -> Void)
    func saveData(dog: Dog)
}

final class DatabaseService {

    private let service: DatabaseServiceProtocol = Settings.shared.activeDatabaseConfiguration

    func fetchData(completion: @escaping(FetchResult) -> Void) {
         service.fetchData(completion: completion)
    }
        
    func saveData(dog: Dog) {
        service.saveData(dog: dog)
    }
}
