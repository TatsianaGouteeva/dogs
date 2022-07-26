//
//  CoreDataManager.swift
//  Dogs
//
//  Created by Inna Markevich on 23.07.22.
//

import Foundation
import CoreData

final class CoreDataManager: DatabaseServiceProtocol {

    private let modelName: String
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var isEmpty: Bool {
        do {
            let count = try managedContext.count(for: DogEntry.fetchRequest())
            return count == 0
        } catch {
            return true
        }
    }

    // MARK: Initializers
    init(modelName: String) {
        self.modelName = modelName
    }

    func fetchDataFromBase(completion: (FetchResult) -> Void) {
        var dogs: [Dog] = []
        do {
            dogs = try managedContext.fetch(DogEntry.fetchRequest())
                .map { dogEntry in
                    return Dog(from: dogEntry)
                }
            completion(.success(dogs))
        } catch let error {
            return completion(.failure(error))
        }
    }

    func fetchData(completion: @escaping(FetchResult) -> Void) {
        if isEmpty {
            completion(.success(JSONDataManager.fetchDataFromJSON()))
        } else {
            fetchDataFromBase { result in
                switch result {
                case .success(let dogs):
                    completion(.success(dogs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func saveData(dog: Dog) {
        let dogModelEntity = NSEntityDescription.entity(forEntityName: "DogEntry", in: managedContext)!
        let dogEntity = DogEntry(entity: dogModelEntity, insertInto: managedContext)
        dogEntity.breed = dog.breed
        dogEntity.height = dog.height.orZero
        dogEntity.weight = dog.weight.orZero
        dogEntity.images = dog.images
        saveContext()
    }

    func fetchDataFromJSON() -> [Dog] {
        var dogs: [Dog] = [Dog]()
        dogs = JSONLoader.shared.load(from: "dogs")!
        let dogModelEntity = NSEntityDescription.entity(forEntityName: "DogEntry", in: managedContext)!
        for dogElement in dogs {
            let dogEntity = DogEntry(entity: dogModelEntity, insertInto: managedContext)
            dogEntity.breed = dogElement.breed
            dogEntity.height = dogElement.height ?? 0.0
            dogEntity.weight = dogElement.weight ?? 0.0
            dogEntity.images = dogElement.images
        }
        saveContext()
        return dogs
    }

// debug
   private func clearDatabase() {
        do {
            let results = try managedContext.fetch(DogEntry.fetchRequest())
            results.forEach({ managedContext.delete($0) })
            saveContext()
        } catch {
            print()
        }
    }


}

extension CoreDataManager {

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
