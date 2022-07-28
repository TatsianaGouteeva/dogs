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
    
    // MARK: Initializers
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: - Protocol implementation
    
    func checkemptyDatabase(completion: @escaping(Bool) -> Void) {
        do {
            let count = try managedContext.count(for: DogEntry.fetchRequest())
            return completion(count == 0)
        } catch {
            return completion(true)
        }
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

    
    func fetchDataFromJSON() -> [Dog] {
        var dogs: [Dog] = [Dog]()
        dogs = JSONLoader.shared.load(from: "dogs")!
        dogs.forEach {
            saveData(dog: $0)
        }
        return dogs
    }
    
    func fetchData(completion: @escaping(FetchResult) -> Void) {
        checkemptyDatabase { [weak self] isEmpty in
            guard let weakSelf = self else {
                completion(.failure(DataError.unknown))
                return
            }
            if isEmpty {
                completion(.success(weakSelf.fetchDataFromJSON()))
            } else {
                weakSelf.fetchDataFromBase { result in
                    switch result {
                    case .success(let dogs):
                        completion(.success(dogs.sorted(by: { $0.breed < $1.breed })))
                    case .failure(let error):
                        completion(.failure(error))
                    }
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
