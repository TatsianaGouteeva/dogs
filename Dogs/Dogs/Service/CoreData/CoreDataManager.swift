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
    
    func fetchDataFromJSON() -> [Dog] {
        var dogs: [Dog] = [Dog]()
        dogs = JSONLoader.shared.load(from: "dogs")!
        dogs.forEach {
            saveData(dog: $0)
        }
        return dogs
    }
    
    func fetchData(completion: @escaping(FetchResult) -> Void) {

        var dogs: [Dog] = []
        do {
            let fetchedDogs = try managedContext.fetch(DogEntity.fetchRequest())
            if fetchedDogs.isEmpty {
                dogs = fetchDataFromJSON()
            } else {
                dogs = fetchedDogs.map { dogEntity in
                    return Dog(from: dogEntity)
                }
            }
            completion(.success(dogs.sorted(by: { $0.breed < $1.breed })))
        } catch let error {
            return completion(.failure(error))
        }
    }
    
    func saveData(dog: Dog) {
        let dogModelEntity = NSEntityDescription.entity(forEntityName: "DogEntity", in: managedContext)!
        let dogEntity = DogEntity(entity: dogModelEntity, insertInto: managedContext)
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
