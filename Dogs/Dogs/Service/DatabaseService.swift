//
//  DatabaseService.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/23/22.
//

import Foundation

typealias FetchResult = Result<[Dog], Error>

protocol DatabaseServiceProtocol {
    var isEmpty: Bool { get }
    //func fetchData() -> [Dog]
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

//    func fetchDataFromJSON(from file: String) -> [Dog] {
//        return [Dog]()
//        //service?.fetchDataFromJSON(from: file) ?? [Dog]()
//    }

//    func updateDataIfNeeded(completion: @escaping(FetchResult) -> Void) {
//        fetchData(completion: completion)
//    }
}
