//
//  RealmDataManager.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

import RealmSwift

final class RealmDataManager: DatabaseServiceProtocol {
    
   func checkemptyDatabase(completion: @escaping(Bool) -> Void) {
        guard let count = try? Realm().objects(DogObject.self).count else {
            completion(true)
            return
        }
        completion(count == 0)
    }
    
    func fetchDataFromBase(completion: @escaping(FetchResult) -> Void) {
        guard let realm = try? Realm() else {
            completion(.failure(DataError.unknown))
            return
        }
        let dogObjects = realm.objects(DogObject.self)
        completion(.success(dogObjects.map { Dog(from: $0) }))
    }
    
    func fetchDataFromJSON() -> [Dog] {
        JSONLoader.shared.load(from: "dogs").orEmpty
    }

    func fetchData(completion: @escaping(FetchResult) -> Void) {
        checkemptyDatabase { [ weak self ] isEmpty in
            guard let weakSelf = self else {
                completion(.failure(DataError.unknown))
                return
            }
            if isEmpty {
                weakSelf.fetchDataFromBase(completion: completion)
            } else {
                let dogs = weakSelf.fetchDataFromJSON()
                dogs.forEach { weakSelf.saveData(dog: $0) }
                completion(.success(dogs))
            }
        }
    }
    
    func saveData(dog: Dog) {
        guard let realm = try? Realm() else { return }

        try? realm.write { realm.add(DogObject(from: dog)) }
    }
}
