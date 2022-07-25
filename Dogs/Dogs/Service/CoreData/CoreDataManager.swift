//
//  CoreDataManager.swift
//  Dogs
//
//  Created by Inna Markevich on 23.07.22.
//

import Foundation
import CoreData

class CoreDataStack: DatabaseServiceProtocol {

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

    func fetchDataFromBase() -> [Dog] {

        var dogs: [Dog] = []
        do {
            dogs = try managedContext.fetch(DogEntry.fetchRequest())
                .map { dogEntry in
                    return Dog(breed: dogEntry.breed ?? "",
                               height: dogEntry.height,
                               weight: dogEntry.weight,
                               description: dogEntry.description,
                               images: dogEntry.images)

                }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        return dogs
    }

    func fetchData() -> [Dog] {
        var dogs: [Dog] = []
        if isEmpty {
            dogs = JSONDataManager.fetchDataFromJSON()
        } else {
            dogs = fetchDataFromBase()
        }
        return dogs
    }

    func saveData(dog: Dog) {
        do {
            let dogModelEntity = NSEntityDescription.entity(forEntityName: "DogEntry", in: managedContext)!
            let dogEntity = DogEntry(entity: dogModelEntity, insertInto: managedContext)
            dogEntity.breed = dog.breed
            dogEntity.height = dog.height ?? 0.0
            dogEntity.weight = dog.weight ?? 0.0
            dogEntity.images = dog.images
            saveContext()
        } catch let error as NSError {
            print("")
        }
    }

    func fetchDataFromJSON() -> [Dog] {

        var dogs: [Dog] = []
        do {
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
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        return dogs
    }

    func clearDatabase() {
        do {
            let results = try managedContext.fetch(DogEntry.fetchRequest())
            results.forEach({ managedContext.delete($0) })
            saveContext()
        } catch {
            print()
        }
    }

    // MARK: Initializers
    init(modelName: String) {
        self.modelName = modelName
    }
}

extension CoreDataStack {
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
