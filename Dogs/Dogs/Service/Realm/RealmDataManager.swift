//
//  RealmDataManager.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

//import RealmSwift
//
//final class RealmDataManager: DatabaseServiceProtocol {
//    
//    var isEmpty: Bool {
//        guard let count = try? Realm().objects(DogObject.self).count else { return true }
//        
//        return count == 0
//    }
//
//    func fetchData() -> [Dog] {
//        guard isEmpty else { return  fetchDataFromBase() }
//
//        let dogs = fetchDataFromJSON()
//        dogs.forEach { saveData(dog: $0) }
//        return dogs
//    }
//    
//    func fetchDataFromBase() -> [Dog] {
//        guard let realm = try? Realm() else { return [] }
//        
//        let dogObjects = realm.objects(DogObject.self)
//        return dogObjects.map { Dog(from: $0) }
//    }
//    
//    func fetchDataFromJSON() -> [Dog] {
//        JSONLoader.shared.load(from: "dogs").orEmpty
//    }
//    
//    func saveData(dog: Dog) {
//        guard let realm = try? Realm() else { return }
//        
//        try? realm.write { realm.add(DogObject(from: dog)) }
//    }
//}
