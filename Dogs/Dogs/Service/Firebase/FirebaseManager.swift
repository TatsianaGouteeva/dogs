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
            return "Invalid fetched data"
        case .unknown:
            return "Something went wrong"
        }
    }
}

final class FirebaseManager: DatabaseServiceProtocol {
    
    private var databaseRef: DatabaseReference
    private let databaseName = "dogs"

    
    // MARK: Initializers
    
    init(){
        databaseRef = Database.database().reference()
    }
    
    //MARK: - Protocol implementation
    
    func checkemptyDatabase(completion: @escaping(Bool) -> Void) {
        databaseRef.child(databaseName).observe(.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                completion(false)
            } else {
                completion(true)
            }
        })
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
                let result = Array(fetcResult.dogs.values)
                    .sorted(by: { $0.breed < $1.breed })
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        })
    }
    
    func fetchDataFromJSON() -> [Dog] {
        let dogs = JSONLoader.shared.load(from: "dogs").orEmpty
        dogs.forEach {
            saveData(dog: $0) }
        return [Dog]()
    }
    
    func fetchData(completion: @escaping(FetchResult) -> Void) {
        checkemptyDatabase { [weak self] emptyBase in
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
    
    func saveData(dog: Dog) {
        
        databaseRef.child(databaseName).child(dog.breed).setValue(dog.firebaseDictionary)
    }
}
