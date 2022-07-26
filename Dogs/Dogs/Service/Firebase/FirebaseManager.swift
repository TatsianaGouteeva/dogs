//
//  FirebaseManager.swift
//  Dogs
//
//  Created by Inna Markevich on 24.07.22.
//

import Foundation
import Firebase

struct FetcResult: Decodable {
    var dogs: [String: Dog]
}

public enum DataError: Error, LocalizedError {
    case invalidData, unknown

    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .unknown:
            return "Something went wrong"
        }
    }
}

final class FirebaseManager: DatabaseServiceProtocol {
    
    func fetchData(completion: @escaping(FetchResult) -> Void) {
        emptyDatabase { [weak self] emptyBase in
            guard let weakSelf = self else {
                completion(.failure(DataError.unknown))
                return
            }
            if !emptyBase {
                weakSelf.fetchDataFromBase(completion: completion)
            } else {
                completion(.success(weakSelf.fetchDataFromJSON()))
            }
        }
    }

    func fetchDataFromBase(completion: @escaping(FetchResult) -> Void) {
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(DataError.invalidData))
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let fetcResult = try JSONDecoder().decode(FetcResult.self, from: jsonData)
                completion(.success(Array(fetcResult.dogs.values)))
            } catch let error {
                completion(.failure(error))
            }
        })
    }

    func fetchDataFromJSON() -> [Dog] {
        JSONLoader.shared.load(from: "dogs").orEmpty
    }

    var isEmpty: Bool {
        return false
    }

    private var databaseRef: DatabaseReference
    private let databaseName = "dogs"

    init(){
        databaseRef = Database.database().reference()
    }

//    func fetchData(completion: @escaping(FetchResult) -> Void) {
//        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else {
//                completion(.failure(DataError.invalidData))
//                return
//            }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//                let fetcResult = try JSONDecoder().decode(FetcResult.self, from: jsonData)
//                completion(.success(Array(fetcResult.dogs.values)))
//            } catch let error {
//                completion(.failure(error))
//            }
//        })
//    }

    private func emptyDatabase(completion: @escaping(Bool) -> Void) {
        databaseRef.observe(.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }

    func saveData(dog: Dog) {
        databaseRef.child(databaseName).child(dog.breed).setValue(dog.firebaseDictionary)
    }

    func fetchDataFromJSON(from file: String) -> [Dog] {
        return [Dog]()
    }
}
