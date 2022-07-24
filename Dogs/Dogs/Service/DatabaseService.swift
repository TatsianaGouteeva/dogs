//
//  DatabaseService.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/23/22.
//

import Foundation

protocol DatabaseServiceProtocol {
    func fetchData() -> [Dog]
    func saveData(dog: Dog)
    func fetchDataFromJSON(from file: String) -> [Dog]
}

final class DatabaseService: DatabaseServiceProtocol {

    private var service: DatabaseServiceProtocol?
    private var serviceType: DatabaseConfigurationType?

    init() {
        setDatabaseType()
    }

    private var isServiceTypeActual: Bool {
        guard let serviceType = serviceType else { return false }
        return serviceType == Settings.shared.activeDatabaseConfiguration
    }

    func fetchData() -> [Dog] {
        return service?.fetchData() ?? [Dog]()
    }

    func saveData(dog: Dog) {
        service?.saveData(dog: dog)
    }

    func fetchDataFromJSON(from file: String) -> [Dog] {
        service?.fetchDataFromJSON(from: file) ?? [Dog]()
    }

    private func setDatabaseType() {

        let activeService = Settings.shared.activeDatabaseConfiguration
        switch activeService {
        case .coredata:
            service = CoreDataStack(modelName: "Dogs")
            serviceType = .coredata
        case .firebase:
            service = CoreDataStack(modelName: "Dogs")
            serviceType = .firebase
        case .realm:
            service = CoreDataStack(modelName: "Dogs")
            serviceType = .realm
        }
    }

    func updateDataIfNeeded() -> [Dog]? {
        if !isServiceTypeActual {
            setDatabaseType()
        }
        return fetchData()
    }
}
